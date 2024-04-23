function [SubbasinAverageAnnual,Subbasin_WatershedAvg, ReachAverageAnnual] =fun_extractSubbasinAndReachAnnualAverage(filename_rch,filename_sub)
% filename_mgt =  [filenamePath 'output.mgt'];

% sizeNO = 16;
load('Reach_Headers.mat');
load('Sub_headers.mat');
load('Suubasin_Area.mat');
% SubbasinArea = sub_dat(:,3)- monthl_list.*10.^(fix(abs(log10(abs(sub_dat(:,3)))))); % this weird 
%expression gives the lenght of integer-1 of the month_area Database
Suubasin_Area(:,2) = 1:45;
% get the reach file
delimiterIn = ' ';
headerlinesIn = 9;
RCH = importdata(filename_rch,delimiterIn,headerlinesIn);
rch_dat = RCH.data; 
Name = Reach_Headers.Properties.VariableNames;
ReachMonthlyFile = array2table(rch_dat,'VariableNames',Name);

% ReachMonthlyFile.WaterYiledmm = ReachMonthlyFile.FLOW_OUTcms*8640000./(10^6*ReachMonthlyFile.AREAkm2);%mm
% ReachMonthlyFile.NitrateYiledkgha = ReachMonthlyFile.NO3_OUTkg./(ReachMonthlyFile.AREAkm2);
% ReachMonthlyFile.TPYiledkgha = ReachMonthlyFile.TOTPkg./(ReachMonthlyFile.AREAkm2);

NameREV = ReachMonthlyFile.Properties.VariableNames;
% extracting the annual average watershed loads from the reach file
ReachAnnualFile = ReachMonthlyFile(ReachMonthlyFile.MON>16,:);
% ReachAnnualAvgFile = ReachMonthlyFile(ReachMonthlyFile.MON==16,:);

[sizeA, sizeB] = size(ReachAnnualFile);

%% Reach Loads Revised and Sediment: The one to use in the Final Data; Not the one with
% 16 as the final value  in MON column; That is errorneous

ReachAnnualAvgFile_Revised = array2table(mean(permute(reshape(table2array(ReachAnnualFile), [45 16 sizeB]),[1 3 2]),3),'VariableNames',NameREV);

ReachAverageAnnual=ReachAnnualAvgFile_Revised;

ReachAverageAnnual.WaterYiledmm = ReachAverageAnnual.FLOW_OUTcms*86400000*365./(10^6*ReachAverageAnnual.AREAkm2);%mm
ReachAverageAnnual.NitrateYiledkgha = ReachAverageAnnual.NO3_OUTkg./(ReachAverageAnnual.AREAkm2*100);
ReachAverageAnnual.TPYiledkgha = ReachAverageAnnual.TOTPkg./(ReachAverageAnnual.AREAkm2*100);

% get the yeild file from output.sub file
delimiterIn = ' ';
headerlinesIn = 9;
SUB = importdata(filename_sub,delimiterIn,headerlinesIn);
sub_dat = SUB.data; 
sub_dat(isnan(sub_dat (:,1)),:)=[]; % take out unnecessary NaNs
NameSUB = Sub_headers.Properties.VariableNames;
SubMonthlyFile = array2table(sub_dat,'VariableNames',NameSUB);
SubMonthlyFile.MON = ReachMonthlyFile.MON;
[loca,locb]=ismember(SubMonthlyFile.SUB,Suubasin_Area(:,2));
SubMonthlyFile.AREAha =Suubasin_Area(locb,1);

NameSUB2 = SubMonthlyFile.Properties.VariableNames;

AnnaulAvgSUB =SubMonthlyFile;


%% Ignore this later

SubbasinAnnualFile = AnnaulAvgSUB(AnnaulAvgSUB.MON>16,:);
% SubbasinAnnualAvgFile = AnnaulAvgSUB(AnnaulAvgSUB.MON==16,:);
SubbasinAnnualAvgFile_Revised = array2table(mean(permute(reshape(table2array(SubbasinAnnualFile), [45 16 29]),[1 3 2]),3),'VariableNames',NameSUB2);

SubbasinAnnualAvgFile_Revised.Nitrogenkgha = SubbasinAnnualAvgFile_Revised.ORGNkgha+SubbasinAnnualAvgFile_Revised.NSURQkgha+...
    SubbasinAnnualAvgFile_Revised.LATNO3kgh+SubbasinAnnualAvgFile_Revised.GWNO3kgha+SubbasinAnnualAvgFile_Revised.TNO3kgha ;

% Nitrate

SubbasinAnnualAvgFile_Revised.Nitratekgha =SubbasinAnnualAvgFile_Revised.NSURQkgha+...
    SubbasinAnnualAvgFile_Revised.LATNO3kgh+SubbasinAnnualAvgFile_Revised.GWNO3kgha+SubbasinAnnualAvgFile_Revised.TNO3kgha;

%Organic N
SubbasinAnnualAvgFile_Revised.OrgNitrogenkgha = SubbasinAnnualAvgFile_Revised.ORGNkgha;

% Phosphorus
SubbasinAnnualAvgFile_Revised.Phosphoruskgha = SubbasinAnnualAvgFile_Revised.ORGPkgha+...
    SubbasinAnnualAvgFile_Revised.SOLPkgha+SubbasinAnnualAvgFile_Revised.SEDPkgha;

SubbasinAverageAnnual = SubbasinAnnualAvgFile_Revised;
% AnnaulSUB =AnnaulAvgSUB(AnnaulAvgSUB.MON>sizeNO,:);
% AnnaulAvgSUB =AnnaulAvgSUB(AnnaulAvgSUB.MON==sizeNO,:);

%% Watershed Average Data
SubbasinHeaders = SubbasinAverageAnnual.Properties.VariableNames;
 Subbasin_WatershedAvg = array2table( sum(SubbasinAverageAnnual{:,:}.*Suubasin_Area(:,1),1)./sum(Suubasin_Area(:,1)), 'VariableNames',SubbasinHeaders);

