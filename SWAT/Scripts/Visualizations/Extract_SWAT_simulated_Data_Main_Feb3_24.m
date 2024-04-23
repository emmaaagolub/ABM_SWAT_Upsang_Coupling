
clear
clc
close all

% Define source folders
sourceFolders = {
    'C:\SWAT\SWATprojects\SWAT_Sundar\SWAT2012-Usang_Baseline\SWAT2012-Usang_Baseline\Model\Baseline\Weighted\20percent\'};
    %'C:\SWAT\SWATprojects\SWAT_Sundar\SWAT2012-Usang_Baseline\SWAT2012-Usang_Baseline\Model\Baseline\Weighted\30percent\'};
    %'C:\SWAT\SWATprojects\SWAT_Sundar\SWAT2012-Usang_Baseline\SWAT2012-Usang_Baseline\Model\Baseline\CRP\MISG_exe4\'};
    %'C:\SWAT\SWATprojects\SWAT_Sundar\SWAT2012-Usang_Baseline\SWAT2012-Usang_Baseline\Model\Baseline\TMDL\MISG_exe4\'};
    % 'C:\SWAT\SWATprojects\SWAT_Sundar\SWAT2012-Usang_Baseline\SWAT2012-Usang_Baseline\Model\Baseline\Environ_only\MISG_exe3\', ...
    % 'C:\SWAT\SWATprojects\SWAT_Sundar\SWAT2012-Usang_Baseline\SWAT2012-Usang_Baseline\Model\Baseline\Environ_only\MISG_exe4\',...
    % 'C:\SWAT\SWATprojects\SWAT_Sundar\SWAT2012-Usang_Baseline\SWAT2012-Usang_Baseline\Model\Baseline\Environ\MISG_exe3\', ...
    % 'C:\SWAT\SWATprojects\SWAT_Sundar\SWAT2012-Usang_Baseline\SWAT2012-Usang_Baseline\Model\Baseline\Environ\MISG_exe4\', ...
    %'C:\SWAT\SWATprojects\SWAT_Sundar\SWAT2012-Usang_Baseline\SWAT2012-Usang_Baseline\Model\Baseline\Baseline\'};

% Specify the base directory
baseDir = 'C:\SWAT\SWATprojects\SWAT_Sundar\SWAT2012-Usang_Baseline\SWAT2012-Usang_Baseline\Scripts\Visualization_Scripts\output\';

% Loop through source folders
for idx = 1:length(sourceFolders)
    sourceFolder = sourceFolders{idx};

    % Extract the final subdirectory name
    [~, folderName, ~] = fileparts(fileparts(sourceFolder));

    filename_rch = [sourceFolder 'output.rch'];
    
    % get the reach outputs at monthly scale -- from model runs at monthly scale
    [Swat_Reach_Outputs_Monthly] = fun_readSWATCalReachAllVariable(filename_rch);
    
    % Get the reach outputs at daily scale -- from model runs at daily scale --
    % may show error as currrent Baseline is simulated only at monthly scale
    % should work with daily runs -- change this settings in file.cio
    %[Swat_Reach_Outputs_Daily] = fun_readSWATCalReachAllVariable(filename_rch);
    
    % Get the Annual Average Yields from output.sub and loads from output.rch
    filename_sub = [sourceFolder 'output.sub'];
    [SubbasinAverageAnnual,Subbasin_WatershedAvg, ReachAverageAnnual] =fun_extractSubbasinAndReachAnnualAverage(filename_rch,filename_sub);
    
    % Extract the crop yield information from output.mgt
    filename_mgt = [sourceFolder 'output.mgt'];
    [CropYieldTable_HRUscale, CropYieldTable_SubbasinScale] = fun_extract_crop_yield_extended (filename_mgt); 
    
    
    % Get the annual average values for corn as an example
            %Filter out years before 2003 as these are spinup results
             Yield_from2003 = CropYieldTable_SubbasinScale(CropYieldTable_SubbasinScale.Year>2002,:);
     
               CornYeildData = reshape(Yield_from2003.CornYield_kg_ha,45,16); %45 is subbasin and 16 is the number of years from 2003 to 2018
               Ann_avg_corn= nanmean(CornYeildData,2).*0.016;  % from kg/ha to bu/ac : note should multiply by 0.015 for soybean


   % Save output tables to a local folder
    outputFolder = fullfile(baseDir, folderName);
    
    % Check if output folder already exists
    if exist(outputFolder, 'dir') ~= 7
        mkdir(outputFolder);
    end
    
% Save tables
    writetable(Swat_Reach_Outputs_Monthly, fullfile(outputFolder, 'Swat_Reach_Outputs_Monthly.csv'));
    writetable(SubbasinAverageAnnual, fullfile(outputFolder, 'SubbasinAverageAnnual.csv'));
    writetable(Subbasin_WatershedAvg, fullfile(outputFolder, 'Subbasin_WatershedAvg.csv'));
    writetable(ReachAverageAnnual, fullfile(outputFolder, 'ReachAverageAnnual.csv'));
    writetable(CropYieldTable_HRUscale, fullfile(outputFolder, 'CropYieldTable_HRUscale.csv'));
    writetable(CropYieldTable_SubbasinScale, fullfile(outputFolder, 'CropYieldTable_SubbasinScale.csv'));
end