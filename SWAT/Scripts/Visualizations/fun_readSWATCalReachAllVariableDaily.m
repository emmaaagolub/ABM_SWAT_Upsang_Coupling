 function [SwatOutputs] = fun_readSWATCalReachAllVariableDaily(filename_rch)
% read the file
% filename_rch ='D:\Project INFEWS\INFEWS_GIS\ArcProjects\Calibration\SwatCupCalibration\June2020Mon.Sufi2.SwatCup\output.rch';

delimiterIn = ' ';
headerlinesIn = 9;
RCH = importdata(filename_rch,delimiterIn,headerlinesIn);
rch_dat = RCH.data; clear RCH

 reach = [7 19 32 34 37 30]; % Fisher, Monticello, Deactur, Outlet
AllVariable =[ 7 11 18 49] ;% Flow,  Sediment, Nitrate, TP

%  reach = [7 19 32 31 37]; % Fisher, Monticello, Deactur, Outlet
% AllVariable =[ 7 11 24 49] ;% Flow,  Sediment, Nitrate, TP

AllVarsData = [];
for allVars = 1:length(AllVariable)
    AllReachData = [];
                for rch= 1:length(reach) 
                    %    reachIndex = find(rch_dat(:,1)==reach(rch));
                        onlyoneReach = rch_dat(rch_dat(:,1)==reach(rch),:);
%                         onlyoneReach(onlyoneReach(:,3)>12,:)=[]; % removing all the annual and annual average values
                        OutputData= onlyoneReach(:,AllVariable(allVars)-1); % to extract flow
                        AllReachData = [AllReachData OutputData ];
                end
                AllVarsData = [AllVarsData  AllReachData];
end

% ConvertToTable
SwatOutputs = array2table(AllVarsData,'VariableNames',...
    {'FlowFisher','FlowMonticello','FlowDecatur','FlowOutlet','FlowSubbasin37','FlowSubbasin30','SedimentFisher','SedimentMonticello','SedimentDecatur',...
    'SedimentOutlet','SedimentSubbasin37','SedimentSubbasin30','NitrateFisher','NitrateMonticello','NitrateDecatur','NitrateOutlet','NitrateSubbasin37','NitrateSubbasin30','TPFisher','TPMonticello',...
    'TPDecatur','TPOutlet','TPSubbasin37','TPSubbasin30'});



t1 = datetime(2003,1,1,0,0,0);
t2 = datetime(2018,12,31,0,0,0);
t = t1:t2;
Years = year(t)'; Days = day(t)';
% reshape(repmat(2003:2018,12,1),[],192)';
% Months= repmat(1:12,1,16)';
SwatOutputs = addvars(SwatOutputs,Years,Days);

SwatOutputs = movevars(SwatOutputs,'Days','Before','FlowFisher');
SwatOutputs = movevars(SwatOutputs,'Years','Before','Days');


% Move the Subbasin 37 to the end
SwatOutputs = movevars(SwatOutputs, 'FlowSubbasin37', 'After', 'TPSubbasin30');
 SwatOutputs = movevars(SwatOutputs, 'SedimentSubbasin37', 'After', 'FlowSubbasin37');
SwatOutputs = movevars(SwatOutputs, 'NitrateSubbasin37', 'After', 'SedimentSubbasin37');
SwatOutputs = movevars(SwatOutputs, 'TPSubbasin37', 'After', 'NitrateSubbasin37');

SwatOutputs = movevars(SwatOutputs, 'FlowSubbasin30', 'After', 'TPSubbasin37');
 SwatOutputs = movevars(SwatOutputs, 'SedimentSubbasin30', 'After', 'FlowSubbasin30');
SwatOutputs = movevars(SwatOutputs, 'NitrateSubbasin30', 'After', 'SedimentSubbasin30');
SwatOutputs = movevars(SwatOutputs, 'TPSubbasin30', 'After', 'NitrateSubbasin30');


% move subbasin 30 to the end
 end
