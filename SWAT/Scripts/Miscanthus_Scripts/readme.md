MatLAB and Python scripts were developed to automate the process of matching miscanthus patches that emerge in the final year of the ABM simulation to SWAT's hydrologic response units (HRUs). This must be done in order to spatially translate miscanthus adoption into the required simulation scale of the SWAT model. As mentioned in Chapter 6.1, SWAT runs at the HRU scale, in addition to the subbasin and reach scale, to simplify simulation processing time. By lumping all similar soil and land use areas into one response unit, HRUs are essentially the total area in a subbasin with specific land cover, soil type, and slope. Because of their lumped nature and scattered extent, the spatial information necessary for analyzing their overlap with miscanthus patches in ArcGIS is lost. To address this challenge in accurately reflecting miscanthus adoption from the ABM in SWAT's input files, we develop scripts that attempt to best match the HRUs with miscanthus patches based on overlapping soil, slope, and land cover.

![matching_HRU](https://github.com/emmaaagolub/ABM_SWAT_Upsang_Coupling/assets/112973445/a9eef19f-6fc2-413d-81e8-2e00fba7ce92)

These scripts detail how to incorporate miscanthus into SWAT using two techniques: the matching technique and the weighting technique. 

The matching technique creates new HRU IDs for the miscanthus farm patches and matches them as closely as possible to the existing HRU IDs defined in the model based on similar slope, soil, and land cover type combinations. After converting .tiff data into shapefiles, we automate the Spatial Join function using Esri's arcpy package in Python to merge relevant soil, slope, and subbasin characteristics associated with each farm patch identified in the ABM.
The weighting technique allocates miscanthus acreage based on a spatial fraction of miscanthus within each subbasin. Essentially, miscanthus is applied to a fraction of HRUs within a subbasin based on the spatial ratio observed from the ABM output. This method opens the door to another mode of analysis through which we can later investigate the impact of miscanthus adoption extent in percentages on water quality as simulated by SWAT.

These scripts are ultimately used together to conditionally automate the adoption of miscanthus parameters and operation schedules in relevant .mgmt files.

An overarching framework of this procedure is described below:

![methods_flowchart](https://github.com/emmaaagolub/ABM_SWAT_Upsang_Coupling/assets/112973445/ad10cb71-c715-4134-a84b-e62b236465e2)


1. Run _GIS_spatial_joining.py_ with Python **v2.7.18** to automate ArcGIS procedure for
merging slope, soil, and subbasin characteristics.
2. Back in .abmvenv in Python **v3.11.1**, run _HRU_miscanthu_matching.py_ to initiate
automation process of defining the list of overlapped or matched HRUs to select ABM
scenario miscanthus output.
3. Run _HRU_miscanthus_weighting.py_ to automate process of defining alternative weighting
technique to translate ABM miscanthus outputs into SWAT inputs.
4. Switching to MatLAB, run _Adopt_Miscanthus_Main.m_ – specifically section exe4 to
automate matching technique or exe5 to automate weighting technique – to adopt
miscanthus in HRUs for SWAT.
5. Now, copy new files (.mgmt and .opt) produced in workingFolder and replace into a
copied Baseline folder. Rename to the select scenario and HRU technique. Then run
SWAT by clicking _swat.exe_.
6. Then, to extract and save the output, run SWAT_simulated_Data_Main.m for the select
scenario.


Feel free to reach out to egolub2@illinois.edu to obtain a sample "Baseline" folder of all necessary SWAT input files or to receive clarifications on how to use these scripts.
