This folder contains all adjusted code and data that is required to run select policy scenarios in the ABM. This model is an adjusted version of the original "BECT-AM" developed by Yang et al., 2022 (see references below to the paper and original code).

The original model was adjusted for the purposes of enhancing usability, debugging, and changing the region of extent from the Sangamon River Basin to the Upper Sangamon Watershed. Switch cases were defined in the main.py, parameters.py, and visulization_new.py files to help choose policy scenarios more easily. Package inconsistencies were resolved, and the requirements.txt file specifies which packages and versions to install. Please create a virtual environment called ".abmvenv" and make sure to install all appropriate packages into this virtual environment.

The main files to run for the ABM are _main.py_ and _visulization_new.py_.

Sample procedure for running ABM
1. In .abmvenv virtual environment activated (with Python **v3.11.1**), run _main.py_ in ABM
with scenario of choice as prompted. Run-time warnings in the terminal output are
normal.
2. Run _visulization_new.py_ to visualize ABM outputs for the scenario of choice, as
prompted.
3. Run _save_output_to_shp.py_ to save ABM outputs to shapefile for further post-processing.
4. Run _ABM_post_processing_results.py_ to post process some results into .csv files.


For coupling procedure and pre-processing for SWAT: (see scripts in /SWAT/Scripts/Miscanthus_Scripts/)

5.  Run _GIS_spatial_joining.py_ with Python **v2.7.18** to automate ArcGIS procedure for
merging slope, soil, and subbasin characteristics.
6.  Enabling .abmvenv with Python **v3.11.1**, run _HRU_miscanthus_matching.py_ to initiate
automation process of defining the list of overlapped or matched HRUs to select ABM
scenario miscanthus output.
7.  Run _HRU_miscanthus_weighting.py_ to automate process of defining alternative weighting
technique to translate ABM miscanthus outputs into SWAT inputs.


References:
Yang, Pan, Ximing Cai, Xinchen Hu, Qiankun Zhao, Yuanyao Lee, Madhu Khanna, Yoel R. Cortés-Peña, et al. “An Agent-Based Modeling Tool Supporting Bioenergy and Bio-Product Community Communication Regarding Cellulosic Bioeconomy Development.” Renewable and Sustainable Energy Reviews 167 (October 1, 2022): 112745. https://doi.org/10.1016/j.rser.2022.112745.

https://github.com/cabbi-bio/BECT-ABM/tree/main
