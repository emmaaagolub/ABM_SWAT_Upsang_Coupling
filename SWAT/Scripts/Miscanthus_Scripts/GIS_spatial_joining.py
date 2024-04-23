# MAKE SURE TO RUN THIS IN PYTHON 2.7.18 THROUGH ARCGIS PATH. This file may take some time to run (~30 minutes)
import arcpy
import os

# Set local variables
workspace = r"C:\SWAT\SWATprojects\SWAT_Sundar\SWAT2012-Usang_Baseline\SWAT2012-Usang_Baseline\Scripts\Miscanthus_Scripts\ArcGIS"
outworkspace = r"C:\SWAT\SWATprojects\SWAT_Sundar\SWAT2012-Usang_Baseline\SWAT2012-Usang_Baseline\Scripts\Miscanthus_Scripts\ArcGIS"

# Set the paths to your datasets
def run_scenario(scenario):
    if scenario == "bioenergy_baseline":
        targetFeatures = os.path.join(workspace, "bioenergy_farmer_map.shp")
    elif scenario == "bioproduct_baseline":
        targetFeatures = os.path.join(workspace, "bioproduct_farmer_map.shp")
    elif scenario == "environ_only_baseline":
        targetFeatures = os.path.join(workspace, "environ_only_farmer_map.shp")
    elif scenario == "environ_baseline":
        targetFeatures = os.path.join(workspace, "environ_baseline_farmer_map.shp")
    elif scenario == "environ_baseline_TMDL":
        targetFeatures = os.path.join(workspace, "TMDL_farmer_map.shp")
    elif scenario == "environ_baseline_CRP":
        targetFeatures = os.path.join(workspace, "CRP_farmer_map.shp")
    else:
        print("Invalid scenario name")
        return
    

    joinFeatures1 = os.path.join(workspace, "SoilClass.shp")
    joinFeatures2 = os.path.join(workspace, "subs1.shp")
    joinFeatures3 = os.path.join(workspace, "LandSlope.shp")

    # Output
    outfc1 = os.path.join(outworkspace, "soil_joined_{}_py.shp".format(scenario))
    outfc2 = os.path.join(outworkspace, "soil_subbasin_joined_{}_py.shp".format(scenario))
    outfc3 = os.path.join(outworkspace, "soil_slope_subbasin_joined_{}_py.shp".format(scenario))


    # Create a new fieldmappings and add the two input feature classes.
    fieldmappings = arcpy.FieldMappings()
    fieldmap1 = arcpy.FieldMap()
    fieldmap2 = arcpy.FieldMap()
    fieldmap3 = arcpy.FieldMap()


    # Spatial Join for soil type
    fieldmappings.addTable(targetFeatures) # DON'T LOSE THIS LINE

    fieldmap1.addInputField(joinFeatures1, "Soil")
    fieldmappings.addFieldMap(fieldmap1)

    arcpy.analysis.SpatialJoin(
        targetFeatures, joinFeatures1, outfc1,
        join_type="KEEP_ALL", field_mapping=fieldmappings,
        match_option="INTERSECT"
    )

    # Spatial Join for subbasin
    targetFeatures1 = outfc1
    fieldmappings.addTable(targetFeatures1)

    fieldmap2.addInputField(joinFeatures2, "Subbasin")
    fieldmappings.addFieldMap(fieldmap2)

    arcpy.analysis.SpatialJoin(
        targetFeatures1, joinFeatures2, outfc2,
        join_type="KEEP_ALL", field_mapping=fieldmappings,
        match_option="INTERSECT"
    )

    # Spatial Join for slope type
    targetFeatures2 = outfc2
    fieldmappings.addTable(targetFeatures2)

    fieldmap3.addInputField(joinFeatures3, "gridcode")
    fieldmappings.addFieldMap(fieldmap3)

    arcpy.analysis.SpatialJoin(
        targetFeatures2, joinFeatures3, outfc3,
        join_type="KEEP_ALL", field_mapping=fieldmappings,
        match_option="INTERSECT"
    )


    # Filter the shapefile attributes to what I need: subbasin, landcover (year 20), Soil, slope (gridcode), area, farmerID, and patchID
    shpf = outfc3 # change to actual name of the joined shapefile you want to work with in ArcGIS "rename" feature

    fields_to_keep = ["Shape","FID","farmer_ID", "patch_ID", "area", "year20", "Subbasin", "Soil", "gridcode"]

    arcpy.management.DeleteField(shpf, [field.name for field in arcpy.ListFields(shpf) if field.name not in fields_to_keep])

# Get user input for scenario selection
scenario = raw_input("Enter scenario name: ")

# Run the selected scenario
run_scenario(scenario)