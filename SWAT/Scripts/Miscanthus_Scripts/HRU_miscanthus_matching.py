# make sure to switch interpreter to Python 3.11.3 .venv environment in ArcGIS folder in Miscanthus Scripts folder

import geopandas as gpd
import os
import pandas as pd
import numpy as np

workspace = r"C:\SWAT\SWATprojects\SWAT_Sundar\SWAT2012-Usang_Baseline\SWAT2012-Usang_Baseline\Scripts\Miscanthus_Scripts\ArcGIS"

# Set the paths to your datasets
def run_scenario(scenario):
    if scenario == "bioenergy_baseline":
        shpf = os.path.join(workspace, "soil_slope_subbasin_joined_bioenergy_baseline_py.shp")
    elif scenario == "environ_only_baseline":
        shpf = os.path.join(workspace, "full_join_py_environ_only.shp")
    elif scenario == "environ_baseline":
        shpf = os.path.join(workspace, "full_join_py_environ_baseline.shp")
    elif scenario == "environ_baseline_TMDL":
        shpf = os.path.join(workspace, "soil_slope_subbasin_joined_environ_baseline_TMDL_py.shp")
    elif scenario == "environ_baseline_CRP":
        shpf = os.path.join(workspace, "soil_slope_subbasin_joined_environ_baseline_CRP_py.shp")
    else:
        print("Invalid scenario name")
        return
    
    # Next, take the shapefile and create a new column called UNIQUECOMB for the HRU combo
        # HRU identifier: subbasin#_landcoverCode_soilCode_slopeRange. i.e.,  1_CRTW_IL010_0-2. This then corresponds to a unique HRU ID# (1-824)

    # Read the shapefile into a GeoDataFrame
    gdf = gpd.read_file(shpf)
    gdf['gridcode'] = gdf['gridcode'].replace({1: "0-2", 2: "2-4", 3: "4-9999"}) # revert back to slope range
    gdf = gdf.rename(columns={'gridcode': 'Slope'})
    filtered_gdf = gdf[gdf['year20'] == 3] # select miscanthus landcover

    # Create the new 'UNIQUECOMB' column
    filtered_gdf['UNIQUECOMB'] = (
        filtered_gdf['Subbasin'].astype(str) +
        '_MISG_' +
        filtered_gdf['Soil'].astype(str) +
        '_' +
        filtered_gdf['Slope'].astype(str)
    )

    # Print or use the filtered GeoDataFrame with the new column
    print(filtered_gdf)

    #%% Next step is matching!

    file_path = r"C:\SWAT\SWATprojects\SWAT_Sundar\SWAT2012-Usang_Baseline\SWAT2012-Usang_Baseline\Scripts\Miscanthus_Scripts"
    excel_data = pd.read_excel(os.path.join(file_path, "SWAT_HRU_mgt_info_USANG.xlsx"), sheet_name="swat-hru-level-info")
    print(excel_data)

    # Convert to dataframes
    df_shapefile = pd.DataFrame(filtered_gdf)
    df_excel = pd.DataFrame(excel_data)

    def match_and_append_uniquecomb(row, df_excel):
        # Extract values from the current row
        soil_value = row['Soil']
        slope_value = row['Slope']
        subbasin_value = row['Subbasin']

        # Find matching rows in df_excel based on conditions
        match_condition = (df_excel['SOIL'] == soil_value) & (df_excel['SLP'] == slope_value) & (df_excel['SUBBASIN'] == subbasin_value)
        matched_rows = df_excel[match_condition]

        # Check for multiple matches
        if len(matched_rows) > 0:
            # Multiple matches, choose the first and append the 'UNIQUECOMB' value to the new column
            row['UNIQUECOMB_MATCH'] = matched_rows['UNIQUECOMB'].iloc[0]
            print(f"Match found for {soil_value}, {slope_value}, {subbasin_value} in df_excel.")
        else:
            # No match found, you can handle this case as needed
            print(f"No match found for {soil_value}, {slope_value}, {subbasin_value} in df_excel.")

        return row

    # Apply the function to each row in df_shapefile
    df_matched = df_shapefile.apply(lambda row: match_and_append_uniquecomb(row, df_excel), axis=1)
    print(df_matched)

    # Count the number of rows where UNIQUECOMB_MATCH is missing
    num_matches_not_found = df_matched['UNIQUECOMB_MATCH'].isna().sum()
    print(f"Number of matches not found: {num_matches_not_found}")

    # Create a list of UNIQUECOMB_MATCH values
    uniquecomb_match_vector = df_matched['UNIQUECOMB_MATCH'].tolist()
    matched_HRUs = [value for value in uniquecomb_match_vector if value is not np.nan]
    unique_matched_HRUs = set(matched_HRUs)
    print(matched_HRUs)
    print(unique_matched_HRUs)

    # Next step is to run matlab script on these select HRUs to represent Miscanthus areas
    # Convert set to a list for compatibility with numpy.savetxt
    unique_matched_HRUs_list = list(unique_matched_HRUs)
    np.savetxt(os.path.join("unique_matched_HRUs_{}.txt".format(scenario)), unique_matched_HRUs_list, fmt='%s')

# Get user input for scenario selection
scenario = input("Enter scenario name: ")

# Run the selected scenario
run_scenario(scenario)