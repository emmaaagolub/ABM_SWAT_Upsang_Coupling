clear
clc
close all

% Obtain the SWAT simulated outputs directly from the simulated folder;
% Example shown for the baseline
sourceFolder = 'C:\SWAT\SWATprojects\SWAT_Sundar\SWAT2012-Usang_Baseline\SWAT2012-Usang_Baseline\Model\Baseline\Baseline\'; % change to SWAT simulation scenario of choice
filename_rch = [sourceFolder 'output.rch'];

% Specify the output folder for saving CSV files
outputFolder = 'C:\SWAT\SWATprojects\SWAT_Sundar\SWAT2012-Usang_Baseline\SWAT2012-Usang_Baseline\Scripts\Visualization_Scripts\output\baseline';

% Create the output folder if it doesn't exist
if ~exist(outputFolder, 'dir')
    mkdir(outputFolder);
end

% Get the reach outputs at monthly scale
[Swat_Reach_Outputs_Monthly] = fun_readSWATCalReachAllVariable(filename_rch);

% Save monthly reach outputs to CSV
writetable([outputFolder 'Swat_Reach_Outputs_Monthly.csv'], Swat_Reach_Outputs_Monthly);

% Get the reach outputs at daily scale
[Swat_Reach_Outputs_Daily] = fun_readSWATCalReachAllVariable(filename_rch);

% Save daily reach outputs to CSV
writetable([outputFolder 'Swat_Reach_Outputs_Daily.csv'], Swat_Reach_Outputs_Daily);

% Get the Annual Average Yields from output.sub and loads from output.rch
filename_sub = [sourceFolder 'output.sub'];
[SubbasinAverageAnnual, Subbasin_WatershedAvg, ReachAverageAnnual] = fun_extractSubbasinAndReachAnnualAverage(filename_rch, filename_sub);

% Save Annual Average Yields to CSV
writetable([outputFolder 'SubbasinAverageAnnual.csv'], SubbasinAverageAnnual);
writetable([outputFolder 'Subbasin_WatershedAvg.csv'], Subbasin_WatershedAvg);
writetable([outputFolder 'ReachAverageAnnual.csv'], ReachAverageAnnual);

% You can explore the code to extract the monthly time-series from
