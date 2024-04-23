import numpy as np
import matplotlib.pyplot as plt
import matplotlib.patches as mpatches
import cal_stats
import pandas as pd
import geopandas as gpd
from PIL import Image, ImageDraw
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

    print(type(simu_result['land_use_areas']))


    # plot land use
    plt.close('all')
    fig, ax = plt.subplots(figsize=(6, 6))
    ax.plot(simu_result['land_use_areas'][:,[0,1,2,3,6,7]])
    ax.legend(['corn','soybean','miscanthus','switchgrass','fallow','CRP'],loc='right',fontsize='small')
    ax.set_xlabel('Year')
    ax.set_ylabel('Area (ha)')
    fig.savefig('total_land_use' + ".jpg", bbox_inches='tight',pad_inches=0.05,dpi=300)

    # plot farmer revenue
    plt.close('all')
    fig, ax = plt.subplots(figsize=(6, 6))
    ax.plot(simu_result['revenue_farmer'])
    fig.savefig('total_farmer_revenue' + ".jpg",bbox_inches='tight',pad_inches=0.05, dpi=300)

    # plot farmer attitude toward perennial grass
    plt.close('all')
    fig, ax = plt.subplots(figsize=(6, 6))
    ax.plot(simu_result['att_farmer'])
    ax.set_xlabel('Year')
    ax.set_ylabel("Farmer's willingness \n to adopt perennial grass")
    fig.savefig('aver_farmer_attitude' + ".jpg",bbox_inches='tight',pad_inches=0.05, dpi=300)

    fig, ax = plt.subplots(figsize=(6, 6))
    ax.plot(simu_result['att_farmer_cluster'])
    ax.set_xlabel('Year')
    ax.set_ylabel("Farmer's willingness \n to adopt perennial grass")
    ax.legend(['Type I','Type II','Type III','Type IV'])
    fig.savefig('farmer_type_attitude' + ".jpg",bbox_inches='tight',pad_inches=0.05, dpi=300)

    fig, ax = plt.subplots(figsize=(6, 6))
    ax.plot(simu_result['adopt_farmer_cluster'])
    ax.set_xticks([0,5,10,15,20])
    ax.set_xlabel('Year')
    ax.set_ylabel('Adoption Ratio')
    ax.legend(['Type I','Type II','Type III','Type IV'])
    fig.savefig('farmer_type_adopt' + ".jpg",bbox_inches='tight',pad_inches=0.05, dpi=300)


    # plot farmer environmental sensitivity
    plt.close('all')
    fig, ax = plt.subplots(figsize=(6, 6))
    ax.plot(simu_result['environ_sensi_farmer'])
    ax.set_xlabel('Year')
    ax.set_ylabel("Farmer's environmental \n sensitivity")
    fig.savefig('aver_farmer_env_sensi' + ".jpg",bbox_inches='tight',pad_inches=0.05, dpi=300)

    # # plot individual farmer's attitude and sensitivity
    # att_farmer_all = cal_stats.extract_farmer_states_nopatch(main.farmer_agent_list,'SC_Will')
    # environ_sensi_farmer_all = cal_stats.extract_farmer_states_nopatch(main.farmer_agent_list,'environ_sen')
    # plt.close('all')
    # fig = plt.figure(figsize=(10, 6))
    # ax1 = plt.subplot(121)
    # ax2 = plt.subplot(122)
    #
    # ax1.plot(att_farmer_all[[0,2,9,67],:].T)
    # ax1.legend(['farmer_1','farmer_3','farmer_10','farmer_68'],loc='upper right',fontsize='medium')
    # ax1.set_xlabel('Year',fontsize='medium')
    # ax1.set_ylabel("Farmer's attitude toward \n perennial grass",fontsize='medium')
    # ax1.set_title("Farmer's attitude toward \n perennial grass",fontsize='medium')
    #
    # ax2.plot(environ_sensi_farmer_all[[0,2,9,67],:].T)
    # ax2.legend(['farmer_1','farmer_3','farmer_10','farmer_68'],loc='upper left',fontsize='medium')
    # ax2.set_xlabel('Year',fontsize='medium')
    # ax2.set_ylabel("Farmer's environmental \n sensitivity",fontsize='medium')
    # ax2.set_title("Farmer's environmental \n sensitivity",fontsize='medium')
    # plt.tight_layout(pad=2, w_pad=2, h_pad=1.0)
    # fig.savefig('indi_farmer_att_sensi' + ".jpg",bbox_inches='tight',pad_inches=0.05, dpi=300)

    #
    # # plot farmer neighborhood impact
    # plt.close('all')
    # fig, ax = plt.subplots(figsize=(6, 6))
    # ax.plot(simu_result['neighbor_impact'])
    # ax.set_xlabel('Year')
    # ax.set_ylabel('Average Neighborhood Impact')
    # fig.savefig('neighbor_impact' + ".jpg",bbox_inches='tight',pad_inches=0.05, dpi=300)


    # plot farmer N release
    plt.close('all')
    fig, ax = plt.subplots(figsize=(6, 6))
    ax.plot(simu_result['N_release']/1000)
    ax.set_xlabel('Year')
    ax.set_ylabel("Total N release (ton)")
    fig.savefig('farmer_N_release' + ".jpg",bbox_inches='tight',pad_inches=0.05, dpi=300)

    # check the land use and contract history
    plt.close('all')
    fig, ax = plt.subplots(figsize=(6, 6))
    ax.plot(simu_result['farmer_adoption'].sum(0)/10)
    ax.plot(simu_result['contract_farm'].sum(0)/10)
    ax.set_xlabel('Year',fontsize=18)
    ax.set_ylabel("Percent",fontsize=18)
    ax.legend(['Perennial Grass Adoption','Farmer Accepting Contract'],fontsize=14)
    fig.savefig('farmer_adoption_his' + ".jpg",bbox_inches='tight',pad_inches=0.05, dpi=300)

    # plot the biofuel production from refineries
    plt.close('all')
    fig = plt.figure(figsize=(10, 6))
    ax1 = plt.subplot(121)
    ax2 = plt.subplot(122)

    ax1.plot(simu_result['biofuel_production'][simu_result['biofuel_type']==1,:].T/10**9)
    temp=[]
    for i in range((simu_result['biofuel_type']==1).sum()):
        temp.append('ref_'+str(i+1))
    ax1.legend(temp,fontsize='medium')
    ax1.set_xlabel('Year',fontsize='medium')
    ax1.set_ylabel('Biofuel Production (Billion L)',fontsize='medium')
    ax1.set_title('Corn Refinery',fontsize='medium')

    ax2.set_title('Cellulosic Refinery',fontsize='medium')
    ax2.set_xlabel('Year',fontsize='medium')
    ax2.set_ylabel('Biofuel Production (Billion L)',fontsize='medium')
    if simu_result['biofuel_production'][simu_result['biofuel_type']==2,:].size >0:
        temp=[]
        for i in range((simu_result['biofuel_type']==2).sum()):
            temp.append('ref_'+str(i + 1 + (simu_result['biofuel_type']==1).sum()))
        ax2.plot(simu_result['biofuel_production'][simu_result['biofuel_type']==2,:].T/10**9)
        ax2.legend(temp,fontsize='medium')
    plt.tight_layout(pad=2, w_pad=2, h_pad=1.0)
    fig.savefig('fuel_production_separate' + ".jpg",bbox_inches='tight',pad_inches=0.05, dpi=300)

    # refinery profit
    plt.close('all')
    fig = plt.figure(figsize=(10, 6))
    ax1 = plt.subplot(121)
    ax2 = plt.subplot(122)

    ax1.plot(simu_result['ref_profit'][simu_result['biofuel_type']==1,:].T/10**6)
    temp=[]
    for i in range((simu_result['biofuel_type']==1).sum()):
        temp.append('ref_'+str(i+1))
    ax1.legend(temp,loc='upper left',fontsize='medium')
    ax1.set_xlabel('Year',fontsize='medium')
    ax1.set_ylabel('Refinery Profit (Million $)',fontsize='medium')
    ax1.set_title('Corn Refinery',fontsize='medium')

    ax2.set_xlabel('Year', fontsize='medium')
    ax2.set_ylabel('Refinery Profit (Million $)', fontsize='medium')
    ax2.set_title('Cellulosic Refinery', fontsize='medium')
    if simu_result['biofuel_production'][simu_result['biofuel_type']==2,:].size >0:
        temp = []
        for i in range((simu_result['biofuel_type'] == 2).sum()):
            temp.append('ref_' + str(i + 1 + (simu_result['biofuel_type'] == 1).sum()))
        ax2.plot(simu_result['ref_profit'][simu_result['biofuel_type']==2,:].T/10**6)
        ax2.legend(temp,loc='upper left',fontsize='medium')
    plt.tight_layout(pad=2, w_pad=2, h_pad=1.0)
    fig.savefig('ref_profit_separate' + ".jpg",bbox_inches='tight',pad_inches=0.05, dpi=300)

    # community water availability
    N_community = simu_result['water_available'].shape[0]
    legend = []
    for i in range(N_community):
        legend.append('Community_' + str(i+1))
    plt.close('all')
    fig = plt.figure(figsize=(10, 5))
    ax1 = plt.subplot(221)
    ax2 = plt.subplot(222)
    ax3 = plt.subplot(223)
    ax4 = plt.subplot(224)

    ax1.plot(simu_result['water_available'].T)
    # ax1.legend(legend)
    ax1.set_xlabel('Year',fontsize='medium')
    ax1.set_ylabel("Water Availability \n (Million L/year)",fontsize='medium')
    ax1.set_title('Community Water Availability',fontsize='medium')
    ax1.legend(legend,fontsize=8)
    ax1.tick_params(labelsize=8)

    ax2.plot(simu_result['commu_N_release'][:,1:].T)
    # ax2.legend(legend)
    ax2.set_xlabel('Year',fontsize='medium')
    ax2.set_ylabel('N Release (ton)',fontsize='medium')
    ax2.set_title('Community N Release',fontsize='medium')
    ax2.legend(legend,fontsize=8)
    ax2.tick_params(labelsize=8)

    ax3.plot(simu_result['commu_atti'].T)
    ax3.legend(legend,fontsize=8)
    ax3.set_xlabel('Year',fontsize='medium')
    ax3.set_ylabel("Community Environmental \n Attitude",fontsize='medium')
    ax3.set_title('Community Environmental Attitude',fontsize='medium')
    ax3.tick_params(labelsize=8)

    labels=[]
    for i in range(N_community):
        labels.append('community'+str(i+1))
    ax4.bar(labels,simu_result['commu_denail'])
    # ax.set_xticks(np.arange(N_community))
    # ax4.set_xticklabels([])
    ax4.set_ylabel('Number of denails',fontsize='medium')
    ax4.set_title('Community denail of new refinery',fontsize='medium')
    ax4.tick_params(labelsize=8)

    plt.tight_layout(pad=2, w_pad=2, h_pad=1.0)
    fig.savefig('commu_stats' + ".jpg",bbox_inches='tight',pad_inches=0.05, dpi=300)

    # TMDL patches
    plt.close('all')
    fig = plt.figure(figsize=(10, 6))
    ax1 = plt.subplot(121)
    ax2 = plt.subplot(122)
    ax1.tick_params(labelsize=12)

    ax1.plot(simu_result['TMDL_eligibilities'].sum(0)/339.65)
    ax1.set_xlabel('Year',fontsize='medium')
    ax1.set_ylabel('Percent',fontsize='medium')
    ax1.set_title('Land Eligible for TMDL Subsidy',fontsize='medium')

    ax2.plot((simu_result['TMDL_eligibilities'] * (np.isin(simu_result['land_use_his'][:,1:],[3,4,5,6]))).sum(0)/339.65)
    ax2.set_xlabel('Year',fontsize='medium')
    ax2.set_ylabel('Percent',fontsize='medium')
    ax2.set_title('Land Participated TMDL',fontsize='medium')
    ax2.tick_params(labelsize=12)
    plt.tight_layout(pad=2, w_pad=2, h_pad=1.0)
    fig.savefig('TMDL_percents' + ".jpg",bbox_inches='tight',pad_inches=0.05, dpi=300)

    # BCAP patches
    plt.close('all')
    fig = plt.figure(figsize=(10, 6))
    ax1 = plt.subplot(121)
    ax2 = plt.subplot(122)

    ax1.plot(simu_result['BCAP_eligibilities'].sum(0)/339.65)
    ax1.set_xlabel('Year',fontsize='medium')
    ax1.set_ylabel('Percent',fontsize='medium')
    ax1.set_title('Land Eligible for BCAP Subsidy',fontsize='medium')
    ax1.tick_params(labelsize=12)

    ax2.plot((simu_result['BCAP_eligibilities'] * (np.isin(simu_result['land_use_his'][:,1:],[3,4]))).sum(0)/339.65)
    ax2.set_xlabel('Year',fontsize='medium')
    ax2.set_ylabel('Percent',fontsize='medium')
    ax2.set_title('Land Participated BCAP',fontsize='medium')
    ax2.tick_params(labelsize=12)
    plt.tight_layout(pad=2, w_pad=2, h_pad=1.0)
    fig.savefig('BCAP_percents' + ".jpg",bbox_inches='tight',pad_inches=0.05, dpi=300)

    # plot recognition of environmental benefits
    plt.close('all')
    fig = plt.figure(figsize=(8, 4))
    ax1 = plt.subplot(221)
    ax2 = plt.subplot(222)
    ax3 = plt.subplot(223)
    ax4 = plt.subplot(224)

    ax1.plot(simu_result['learning_factor']*154.4,'k', linewidth=2.5)
    # ax1.set_xlabel('Year',fontsize='medium')
    ax1.set_ylabel('Farmer perceived \nlong-term economic \nbenefit of \nMiscanthus ($/ha)',fontsize='medium')
    ax1.tick_params(labelsize=12)
    ax1.set_xticklabels([])
    ax1.grid('both')

    ax2.plot(simu_result['WTP'],'k', linewidth=2.5)
    # ax2.set_xlabel('Year',fontsize='medium')
    ax2.set_ylabel('Consumer willingness to \npay for the premium of\n cellulosic biofuel ($/L)',fontsize='medium')
    ax2.tick_params(labelsize=12)
    ax2.set_xticklabels([])
    ax2.grid('both')

    ax3.plot(100-simu_result['ref_pro_cost_adj_his'][:,1]*100,'k', linewidth=2.5)
    ax3.set_xlabel('Year',fontsize='medium')
    ax3.set_ylabel('Reduction of biofuel \nproduction cost (%)',fontsize='medium')
    ax3.tick_params(labelsize=12)
    ax3.grid('both')

    ax4.plot(simu_result['land_use_areas'][:,2]/10**6,'k', linewidth=2.5)
    ax4.set_xlabel('Year',fontsize='medium')
    ax4.set_ylabel('Total Miscanthus \nacreage (Million ha)',fontsize='medium')
    ax4.tick_params(labelsize=12)
    ax4.grid('both')
    plt.tight_layout(pad=2, w_pad=2, h_pad=0.5)
    fig.savefig('EC_recognize' + ".jpg",bbox_inches='tight',pad_inches=0.05, dpi=300)

    #
    ## maps
    loc_dir = os.path.join(params.dir_loc,"data","GIS_upsang") #adjusting to upper sangamon
    farmer_map = gpd.read_file(os.path.join(loc_dir,"farms_sagamon_farm1000_with_urban.shp"))
    marginal_land_map = gpd.read_file(os.path.join(loc_dir,'farms_sagamon_farm1000_with_urban_selected.shp'))
    temp=[]
    for i in range(params.simu_horizon+1):
        temp.append('year'+str(i))
    land_use_his_pd = pd.DataFrame(data=np.vstack((-1*np.ones((1,params.simu_horizon+1),int),simu_result['land_use_his'].astype(int))),columns=temp)
    land_use_his_pd['patch_ID'] = np.arange(len(land_use_his_pd)) - 1
    farmer_map = farmer_map.merge(land_use_his_pd, on='patch_ID')

    ref_locs_map = gpd.read_file(os.path.join(loc_dir,'can_industry_locs.shp'))
    ref_cap_look_up_table = np.asarray([[0,1,2,3,4],[0,200,400,800,800]]).T
    corn_ref_pd,cell_ref_pd,bio_facility_pd=simu_result['corn_ref_pd'],simu_result['cell_ref_pd'],simu_result['bio_facility_pd']
    corn_ref_pd['loc_ID'] = np.arange(len(corn_ref_pd))
    cell_ref_pd['loc_ID'] = np.arange(len(cell_ref_pd))
    corn_loc_map = ref_locs_map.merge(corn_ref_pd,on='loc_ID')
    cell_loc_map = ref_locs_map.merge(cell_ref_pd,on='loc_ID')
    bio_facility_pd['loc_ID'] = np.arange(len(bio_facility_pd))
    bio_loc_map = ref_locs_map.merge(bio_facility_pd,on='loc_ID')

    # cmap_farm = {-1: 'grey',1: '#e6daa6',2: '#6b8ba4',3: '#6fc276',7: '#05480d',8:'#b75203'}
    # labels_farm = {-1: 'urban/water',1: 'corn', 2: 'soy', 3:'miscanthus',7:'fallow',8:'CRP'}
    cmap_farm = {-1: 'grey',1: '#ffd966',2: '#7f6000',3: '#6fc276',7: '#05480d',8:'#b75203'}
    labels_farm = {-1: 'urban/water',1: 'corn', 2: 'soy', 3:'miscanthus',7:'fallow',8:'CRP'}
    patches_farm = [mpatches.Patch(color=cmap_farm[i], label=labels_farm[i]) for i in cmap_farm]
    feature_attributes_farm = []
    for i in range(params.simu_horizon):
        feature_attributes_farm.append('year'+str(i+1))

    cmap_ref_corn = {0: '#d9544d',1: '#fe2c54',2: 'red',3: '#9e0168',4: '#840000'}
    labels_ref_corn = {0: '0-200 ML',1: '200-400 ML', 2: '400-600 ML', 3:'600-800 ML',4:'>800 ML'}
    patches_ref_corn = [ plt.plot([],[], marker="o", ms=8, ls="", mec=None, color=cmap_ref_corn[i],
                label="{:s}".format(labels_ref_corn[i]) )[0]  for i in range(len(labels_ref_corn)) ]
    feature_attributes_ref_corn = []
    for i in range(params.simu_horizon):
        feature_attributes_ref_corn.append('corn_cap_year'+str(i))
    loc_attributes_ref_corn = []
    for i in range(params.simu_horizon):
        loc_attributes_ref_corn.append('corn_loc_year'+str(i))

    cmap_ref_cell = {0: '#d9544d',1: '#fe2c54',2: 'red',3: '#9e0168',4: '#840000'}
    labels_ref_cell = {0: '0-200 ML',1: '200-400 ML', 2: '400-600 ML', 3:'600-800 ML',4:'>800 ML'}
    patches_ref_cell = [ plt.plot([],[], marker="^", ms=8, ls="", mec=None, color=cmap_ref_cell[i],
                label="{:s}".format(labels_ref_cell[i]) )[0]  for i in range(len(labels_ref_cell)) ]
    feature_attributes_ref_cell = []
    for i in range(params.simu_horizon):
        feature_attributes_ref_cell.append('cell_cap_year'+str(i))
    loc_attributes_ref_cell = []
    for i in range(params.simu_horizon):
        loc_attributes_ref_cell.append('cell_loc_year'+str(i))

    cmap_bio_facility = {6: 'green',7: 'blue'}
    labels_bio_facility = {6: 'cofire plant',7: 'BCHP'}
    patches_bio_facility = [ plt.plot([],[], marker="D", ms=4, ls="", mec=None, color=cmap_bio_facility[i],
                label="{:s}".format(labels_bio_facility[i]) )[0]  for i in labels_bio_facility ]
    feature_attributes_bio_facility = []
    for i in range(params.simu_horizon):
        feature_attributes_bio_facility.append('bio_type_year'+str(i))
    loc_attributes_biofacility = []
    for i in range(params.simu_horizon):
        loc_attributes_biofacility.append('bio_loc_year'+str(i))


    biofuel_production_sum = simu_result['biofuel_production'].sum(0)

    cal_stats.draw_gifs_multipatch(farmer_map,marginal_land_map,corn_loc_map,cell_loc_map,bio_loc_map,cmap_farm,cmap_ref_corn,
                                cmap_ref_cell,cmap_bio_facility,feature_attributes_farm,feature_attributes_ref_corn,
                                loc_attributes_ref_corn,feature_attributes_ref_cell,loc_attributes_ref_cell,
                                feature_attributes_bio_facility,loc_attributes_biofacility,patches_farm,patches_ref_corn,
                                patches_ref_cell,patches_bio_facility,simu_result['land_use_areas'],
                                biofuel_production_sum,simu_result['att_farmer'],simu_result['environ_sensi_farmer'],
                                simu_result['N_release'],'land_use_',params.folder
    )

# Get user input for scenario selection
scenario = input("Enter scenario name: ")

# Run the selected scenario
run_scenario(scenario)
