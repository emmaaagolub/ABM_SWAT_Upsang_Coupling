 clear
 close all
 clc
 
 %% read swat output: remember to create a copy of output.rch file to a text file !!
%flow_Swat_mon =readmatrix('D:\Project INFEWS\INFEWS_GIS\ArcProjects\Calibration\SwatCupCalibration\June2020Mon.Sufi2.SwatCup\outputrch.txt'); 
%flow_Swat_mon =readmatrix('C:\SWAT\SWATprojects\SWAT_Sundar\SWAT2012-Usang_Baseline\SWAT2012-Usang_Baseline\Model\Baseline\Environ\MISG_exe4\outputrch.txt'); 
%flow_Swat_mon =readmatrix('C:\SWAT\SWATprojects\SWAT_Sundar\SWAT2012-Usang_Baseline\SWAT2012-Usang_Baseline\Model\Baseline\Environ_only\MISG_exe4\outputrch.txt'); 
%flow_Swat_mon =readmatrix('C:\SWAT\SWATprojects\SWAT_Sundar\SWAT2012-Usang_Baseline\SWAT2012-Usang_Baseline\Model\Baseline\CRP\MISG_exe4\outputrch.txt'); 
%flow_Swat_mon =readmatrix('C:\SWAT\SWATprojects\SWAT_Sundar\SWAT2012-Usang_Baseline\SWAT2012-Usang_Baseline\Model\Baseline\TMDL\MISG_exe4\outputrch.txt'); 
%flow_Swat_mon =readmatrix('C:\SWAT\SWATprojects\SWAT_Sundar\SWAT2012-Usang_Baseline\SWAT2012-Usang_Baseline\Model\Baseline\Weighted\20percent\outputrch.txt'); 
%flow_Swat_mon =readmatrix('C:\SWAT\SWATprojects\SWAT_Sundar\SWAT2012-Usang_Baseline\SWAT2012-Usang_Baseline\Model\Baseline\Weighted\25percent\outputrch.txt'); 
flow_Swat_mon =readmatrix('C:\SWAT\SWATprojects\SWAT_Sundar\SWAT2012-Usang_Baseline\SWAT2012-Usang_Baseline\Model\Baseline\Weighted\30percent\outputrch.txt'); 

SWAT_output = flow_Swat_mon(6:end,2:end);
 reach = [7 19 32 37]; % Fisher, Monticello, Deactur, Outlet 

%%
for rch= 1:length(reach) 
x2 = find(SWAT_output(:,1)==reach(rch));
new_dat = SWAT_output(x2,:);
new_dat(new_dat(:,3)>12,:)=[];
Simulated (:,rch) = new_dat(:,7-1); % to extract  ;% Flow,  Sediment, Nitrate, TP  [7 11 18 49]
end

% load the observed Data
load obsFLow % From third column, Fisher, Monticello, Deactur, Outlet Monthly Flow

% plot the comparison
% calibration
subplot(2,1,1)
lengthChoice = 1:120;
ylabelx = 'm^3/s';
simCalData = Simulated(lengthChoice,1); % Fisher
obsCalData = obsFLow(lengthChoice,3); % Fisher
fun_makeCalValPlots2(simCalData,obsCalData, lengthChoice,ylabelx)
title('Flow Cal at Fisher')
% validation
subplot(2,1,2)
lengthChoice = 121:192;
ylabelx = 'm^3/s';
simCalData = Simulated(lengthChoice,1); % Fisher
obsCalData = obsFLow(lengthChoice,3); % Fisher
fun_makeCalValPlots2(simCalData,obsCalData, lengthChoice,ylabelx)
title('Flow Val at Fisher')