import numpy as np
import cal_stats
import pandas as pd
import geopandas as gpd
import os
import parameters as params

def run_scenario(scenario):
    os.chdir(os.path.join(params.folder, scenario))

    if scenario == "bioenergy_baseline":
        simu_result = cal_stats.extract_ABM_results(os.path.join(params.folder,"results","ABM_result_bioenergy_baseline.out"),1)
    elif scenario == "bioproduct_baseline":
        simu_result = cal_stats.extract_ABM_results(os.path.join(params.folder,"results","ABM_result_bioproduct_baseline.out"),1)
    elif scenario == "environ_only_baseline":
        simu_result = cal_stats.extract_ABM_results(os.path.join(params.folder,"results","ABM_result_environ_only_baseline.out"),1)
    elif scenario == "environ_baseline":
        simu_result = cal_stats.extract_ABM_results(os.path.join(params.folder,"results","ABM_result_environ_baseline.out"),1)
    elif scenario == "environ_baseline_TMDL":
        simu_result = cal_stats.extract_ABM_results(os.path.join(params.folder,"results","ABM_result_environ_baseline_TMDL.out"),1)
    elif scenario == "environ_baseline_CRP":
        simu_result = cal_stats.extract_ABM_results(os.path.join(params.folder,"results","ABM_result_environ_baseline_CRP.out"),1)
    else:
        print("Invalid scenario name")
        return

    loc_dir = os.path.join(params.dir_loc, "data", "GIS_upsang")
    farmer_map = gpd.read_file(os.path.join(loc_dir, "farms_sagamon_farm1000_with_urban.shp"))
    marginal_land_map = gpd.read_file(os.path.join(loc_dir, 'farms_sagamon_farm1000_with_urban_selected.shp'))

    temp = []
    for i in range(params.simu_horizon + 1):
        temp.append('year' + str(i))
    land_use_his_pd = pd.DataFrame(data=np.vstack((-1 * np.ones((1, params.simu_horizon + 1), int), simu_result['land_use_his'].astype(int))),
                                   columns=temp)
    land_use_his_pd['patch_ID'] = np.arange(len(land_use_his_pd)) - 1
    farmer_map = farmer_map.merge(land_use_his_pd, on='patch_ID')

    geo_dir = os.path.join(params.folder, scenario)
    farmer_map.to_file(os.path.join(geo_dir, "{}_farmer_map.shp".format(scenario)), driver='ESRI Shapefile')

# Get user input for scenario selection
scenario = input("Enter scenario name: ")

# Run the selected scenario
run_scenario(scenario)
