%% TO DO: ADOPT SWITCH CASES FOR EACH SCENARIO FOR EASIER AUTOMATION

clearvars
clc
close all

sourceFolder = 'C:\SWAT\SWATprojects\SWAT_Sundar\SWAT2012-Usang_Baseline\SWAT2012-Usang_Baseline\Model\Baseline\Baseline\'; % define your baseline path here
MISGmgtInfo = 'MISG_base.txt'; % Miscanthus management file

%other files including MISG.txt and SWAT_HRU_mgt_info_USANG.xlsx
%should be in the current folder (or at pwd in MATALAB terms)
usangHRU = readtable('SWAT_HRU_mgt_info_USANG.xlsx','Sheet','swat-hru-level-info', 'Range','a1:T826');

%% Make a dir and copy the baseline and name it as workingPath; 
%We will do everything on the working path -- Do it only once: After that comment
% it out

% mkdir ('workingFolder');
% copyfile([sourceFolder '*.*'],[pwd '\workingFolder\'])

% define the working path ; we will work directly here
workingPath = [pwd '\workingFolder\'];
delete(fullfile(workingPath, '*'));

% select only Agricultural HRUs -- defined by Landuse Code 1 to 7
Ag_usangHRU = usangHRU(ismember(usangHRU.LanduseCode,[1:7]),:);

%% Exe 1: lets adopt miscanthus in the first HRU ( only in the Agricultural HRUs)

        % Try this to adopt miscanthus in the first HRU;
        filename  = Ag_usangHRU.HRU_GIS{1}
        fun_adoptMiscanthus(workingPath, sourceFolder, filename, MISGmgtInfo)
 
%% Exe 2: lets adopt miscanthus in the entire watershed (all Ag HRUs)
       
% Try this to adopt miscanthus in the entire Agricultural HRUs
        for eachAgHRU = 1:height(Ag_usangHRU) % read each of the Ag HRUs; work only on Ag Files
                    filename = Ag_usangHRU.HRU_GIS {eachAgHRU}
                    fun_adoptMiscanthus(workingPath, sourceFolder, filename, MISGmgtInfo);
        end
        
%% Exe 3: lets adopt miscanthus in specific subbasins for all agricultural HRUs (working)

% Select only subbasins with miscanthus -- defined by list of specific subbasins that overlapped with ABM output
MISG_usangSUBB = usangHRU(ismember(usangHRU.SUBBASIN,[1,2,3,4,5,6,7,9,10,11,12,14,15,16,17,18,20,21,23,26,29,30,33,34,35,36,38,39,41,42,43,45]),:); % environ only baseline scenario
%MISG_usangSUBB = usangHRU(ismember(usangHRU.SUBBASIN,[1,2,3,4,6,7,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,26,27,28,29,30,32,33,34,36,37,38,39,40,41,42,43,44,45]),:); % environ baseline scenario

% Try this to adopt miscanthus in desired subbasins
        for eachMISGSUBB = 1:height(MISG_usangSUBB)
            subbasinID = MISG_usangSUBB.SUBBASIN(eachMISGSUBB);
            
            for eachAgHRU = 1:height(Ag_usangHRU)
                filename = Ag_usangHRU.HRU_GIS{eachAgHRU};
                % Check if the HRU is in the specified subbasin
                if ismember(Ag_usangHRU.SUBBASIN(eachAgHRU), subbasinID)
                    fun_adoptMiscanthus(workingPath, sourceFolder, filename, MISGmgtInfo);
                end
            end
        end


%% Exe 4: lets match miscanthus farm patches to HRU level as best we can

% Create their own unique HRU combo identifier and match them to existing HRUs defined in SWAT_HRU_management_info.xlsx
% Format of HRU identifier: subbasin#_landcoverCode_soilCode_slopeRange. i.e.,  1_CRTW_IL010_0-2. This then corresponds to a unique HRU ID# (1-824)

% After running python code to produce list of unique UNIQUECOMB values that represent where Miscanthus patches best matched up to:
%unique_matched_HRUs = importdata("C:\SWAT\SWATprojects\SWAT_Sundar\SWAT2012-Usang_Baseline\SWAT2012-Usang_Baseline\Scripts\Miscanthus_Scripts\unique_matched_HRUs_environ_baseline_TMDL.txt");
unique_matched_HRUs = importdata("C:\SWAT\SWATprojects\SWAT_Sundar\SWAT2012-Usang_Baseline\SWAT2012-Usang_Baseline\Scripts\Miscanthus_Scripts\unique_matched_HRUs_environ_baseline_CRP.txt");
%unique_matched_HRUs = importdata("C:\SWAT\SWATprojects\SWAT_Sundar\SWAT2012-Usang_Baseline\SWAT2012-Usang_Baseline\Scripts\Miscanthus_Scripts\unique_matched_HRUs_environ_only.txt");
%unique_matched_HRUs = importdata("C:\SWAT\SWATprojects\SWAT_Sundar\SWAT2012-Usang_Baseline\SWAT2012-Usang_Baseline\Scripts\Miscanthus_Scripts\unique_matched_HRUs_environ.txt");

% Adopt Miscanthus in HRUs only with a UNIQUECOMBO ID in the defined list... that are also agricultural (to avoid including land use like forest):
matched_HRU = usangHRU(ismember(usangHRU.LanduseCode, [1:7]) & ismember(usangHRU.UNIQUECOMB, unique_matched_HRUs), :);
disp(matched_HRU)

        for eachAgHRU = 1:height(matched_HRU) % read each of the Ag HRUs; work only on Ag Files
                    filename = matched_HRU.HRU_GIS {eachAgHRU}
                    fun_adoptMiscanthus(workingPath, sourceFolder, filename, MISGmgtInfo);
        end

%% Exe 5: lets match miscanthus farm patches to HRU level based on percentages
% Get unique subbasin IDs from Ag_usangHRU
unique_subbasins = unique(Ag_usangHRU.SUBBASIN);

% Preallocate a cell array to store filtered HRUs for each subbasin
filtered_HRUs = cell(size(unique_subbasins));

% Iterate over each unique subbasin ID
for i = 1:numel(unique_subbasins)
    subbasinID = unique_subbasins(i);
    
    % Filter HRUs within the current subbasin
    subbasin_HRUs = Ag_usangHRU(Ag_usangHRU.SUBBASIN == subbasinID, :);
    
    % Store filtered HRUs in the cell array
    filtered_HRUs{i} = subbasin_HRUs;
    
    % Determine how many HRUs to adopt Miscanthus (at least 20% of total HRUs in the subbasin)
    num_HRUs_subbasin = height(subbasin_HRUs);
    num_HRUs_to_adopt_miscanthus = ceil(0.20 * num_HRUs_subbasin); % you can change the percent here to play with it
    fprintf('Subbasin %d has %d HRUs. Selecting %d HRUs to adopt Miscanthus.\n', subbasinID, num_HRUs_subbasin, num_HRUs_to_adopt_miscanthus);
    
    % Randomly select HRUs to adopt Miscanthus
    selected_indices = randperm(num_HRUs_subbasin, num_HRUs_to_adopt_miscanthus);
    
    % Iterate over selected HRUs and adopt Miscanthus
    for idx = 1:numel(selected_indices)
        hru_index = selected_indices(idx);
        filename = subbasin_HRUs.HRU_GIS{hru_index};
        fun_adoptMiscanthus(workingPath, sourceFolder, filename, MISGmgtInfo);
    end
end



