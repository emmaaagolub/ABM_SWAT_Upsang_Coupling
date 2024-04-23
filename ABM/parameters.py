import numpy as np
import os

#dir_loc = os.path.dirname(r"C:\Users\egolub2\BiofuelABM\ABM_insight_model_OG\main.py")

# Define working file directory
dir_loc = os.path.dirname(__file__)
print(dir_loc)

folder = os.path.join(dir_loc, "simulations", "baseline")
result_files = {
    "bioenergy_baseline": os.path.join(folder, "results", "ABM_result_bioenergy_baseline.out"),
    "bioproduct_baseline": os.path.join(folder, "results", "ABM_result_bioproduct_baseline.out"),
    "environ_only_baseline": os.path.join(folder, "results", "ABM_result_environ_only_baseline.out"),
    "environ_baseline": os.path.join(folder, "results", "ABM_result_environ_baseline.out"),
    "environ_baseline_TMDL": os.path.join(folder, "results", "ABM_result_environ_baseline_TMDL.out"),
    "environ_baseline_CRP": os.path.join(folder, "results", "ABM_result_environ_baseline_CRP.out"),
}

print("Select a scenario for parameters file:")
print("bioenergy_baseline")
print("bioproduct_baseline")
print("environ_baseline")
print("environ_only_baseline")
print("environ_baseline_TMDL")
print("environ_baseline_CRP")
scenario = input("Enter scenario name for parameters file: ")

result_file = result_files.get(scenario)
if result_file is None:
    print("Invalid scenario name")
else:
    # Proceed with your code using the `result_file`
    print("Scenario selected:", scenario)


ins_folder = os.path.join(dir_loc, "insight")
meth_folder = os.path.join(dir_loc, "methodology")
simu_horizon = 20


# farmer related parameters
land_rent = 218 * 2.47  # in $/ha
marginal_land_rent_adj = 0.5 # the land rent reduction of marginal land
# enhanced_neighbor_impact = [0, 1, 2] # the level of neighborhood impact
farm_type_change_prob=0

# industry related parameters
learn_by_do_rate = np.log(0.95)/np.log(2) # the cost updating rate for learning by doing
# learn_by_do_rate = 0 # the cost updating rate for learning by doing, assuming no learning by doing
base_cap_for_learn_by_do = 200*10**6 # the base capacity for learning by doing, L
base_BCHP_cap_for_learn_by_do = 4 # the base capacity of BCHP, in unit of BCHP plant
base_feed_amount_for_learn_by_do = 4*10**4 # the base feedstock amount for the learning by doing of supply chain business, ton
allowable_defecit = 0.4

is_ref_learn_by_do = 1 # if the refinery production cost need to be updated based on learning by doing
ref_inv_cost_adj_his = np.ones((simu_horizon + 1, 4))  # the investment cost adjustment of learning by doing
ref_inv_cost_adj_his[np.round(simu_horizon/2).astype(int):,1] = 0.5
ref_pro_cost_adj_his = np.ones((simu_horizon + 1, 4))  # the production cost adjustment of learning by doing
ref_pro_cost_adj_his[np.round(simu_horizon/2).astype(int):,1] = 0.5

# consumer related parameters
ini_WP = 0.001    # initial willingness to pay extra for cellulosic ethanol in $/gallon
IRW = 0.5      # increasing rate factor of WP
max_WP = 0.12   # maximum value of WP

price_update_rate = 0.3 # the parameter for forecasting prices

# government related parameters
maintain_RFS = 0 # if gov determined to maintain the RFS mandate
CRP_subsidy = 300    #$/ha
CRP_relax = 0 # if perennial grass harvesting in CRP land is allowed
IRR_adj_rate = 0.02

TMDL_subsidy = 60 * 2.47 #60$/acre uses hectare for compiliation
#TMDL_subsidy=0

# BCAP_subsidy = 0 # in $/ha
# BCAP_cost_share = 0
BCAP_subsidy = 1000 * 2.47/15 # in $/ha
BCAP_cost_share = 0.5

tax_deduction = 0
tax_rate = 0

carbon_price = 0*np.ones(simu_horizon) # $/t CO2e
nitrogen_price = 0 # $/kg

# market related parameters
lambda_market = 0.3 # the lambda parameter for updating biomass market price

