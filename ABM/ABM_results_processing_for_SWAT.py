import csv
import numpy as np
import os
import cal_stats
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

    land_use_filename = 'land_use_areas.csv'
    with open(land_use_filename, 'w', newline='') as csvfile:
        writer = csv.writer(csvfile)
        writer.writerow(['Year', 'Corn', 'Soybean', 'Miscanthus', 'Switchgrass', 'Fallow', 'CRP'])
        for year, values in enumerate(simu_result['land_use_areas'][:,[0,1,2,3,6,7]]):
            writer.writerow([year, *values])

    revenue_filename = 'farmer_revenue.csv'
    with open(revenue_filename, 'w', newline='') as csvfile:
        writer = csv.writer(csvfile)
        writer.writerow(['Year', 'Revenue'])
        for year, revenue in enumerate(simu_result['revenue_farmer']):
            writer.writerow([year, revenue])

    attitude_filename = 'farmer_attitude.csv'
    with open(attitude_filename, 'w', newline='') as csvfile:
        writer = csv.writer(csvfile)
        writer.writerow(['Year', "Farmer's Willingness to Adopt Perennial Grass"])
        for year, attitude in enumerate(simu_result['att_farmer']):
            writer.writerow([year, attitude])

    env_sens_filename = 'environmental_sensitivity.csv'
    with open(env_sens_filename, 'w', newline='') as csvfile:
        writer = csv.writer(csvfile)
        writer.writerow(['Year', "Farmer's environmental sensitivity"])
        for year, sensitivity in enumerate(simu_result['environ_sensi_farmer']):
            writer.writerow([year, sensitivity])

    n_release_filename = 'N_release.csv'
    with open(n_release_filename, 'w', newline='') as csvfile:
        writer = csv.writer(csvfile)
        writer.writerow(['Year', "Total N release (ton)"])
        for year, n_release in enumerate(simu_result['N_release']/1000):
            writer.writerow([year, n_release])

    biofuel_prod_filename = 'biofuel_production.csv'
    headers = ["Year"]
    refinery_labels = []
    for i in range(simu_result['biofuel_production'].shape[0]):
        headers.append(f"Refinery_{i + 1}_Biofuel_Production_Billion_L")
    with open(biofuel_prod_filename, 'w', newline='') as csvfile:
        csv_writer = csv.writer(csvfile)
        csv_writer.writerow(headers)
        for year, biofuel_production in enumerate(simu_result['biofuel_production'].T):
            row = [year]
            row.extend(biofuel_production.tolist())
            csv_writer.writerow(row)

    water_avail_filename = 'water_avail.csv'
    with open(water_avail_filename, 'w', newline='') as csvfile:
        writer = csv.writer(csvfile)
        writer.writerow(['Year', "Water Availability \n (Million L/year)"])
        for year, avail in enumerate(simu_result['water_available'].T):
            writer.writerow([year, avail])

    tmdl_elig_filename = 'tmdl_eligibilities.csv'
    with open(tmdl_elig_filename, 'w', newline='') as csvfile:
        writer = csv.writer(csvfile)
        writer.writerow(['Year', "Land Eligible for TMDL Subsidy"])
        for year, tmdl in enumerate(simu_result['TMDL_eligibilities'].sum(0)/339.65):
            writer.writerow([year, tmdl])

    tmdl_partic_filename = 'tmdl_participation.csv'
    with open(tmdl_partic_filename, 'w', newline='') as csvfile:
        writer = csv.writer(csvfile)
        writer.writerow(['Year', "Land Participated in TMDL Subsidy"])
        for year, tmdl in enumerate((simu_result['TMDL_eligibilities'] * (np.isin(simu_result['land_use_his'][:,1:],[3,4,5,6]))).sum(0)/339.65):
            writer.writerow([year, tmdl])

    miscanthus_filename = 'miscanthus_acreage.csv'
    with open(miscanthus_filename, 'w', newline='') as csvfile:
        writer = csv.writer(csvfile)
        writer.writerow(['Year', "Total Miscanthus acreage (Million Ha)"])
        for year, acreage in enumerate(simu_result['land_use_areas'][:,2]/10**6):
            writer.writerow([year, acreage])

# Get user input for scenario selection
scenario = input("Enter scenario name: ")

# Run the selected scenario
run_scenario(scenario)
