function []= fun_makeCalValPlots2(simCalData,obsCalData, lengthChoice,ylabelx)

combineData= [simCalData obsCalData]; 
combineData(any(isnan(combineData), 2), :) = []; % remove any nan
cumCombineData= cumsum(combineData);

yyaxis left
plot(lengthChoice,simCalData,'-r','linewidth',2); hold on;
plot(lengthChoice,obsCalData,'-b','linewidth',2);
xlabel('Months'); ylabel([ylabelx]); hold off;
yyaxis right
plot(lengthChoice(1):lengthChoice(1)+length(cumCombineData)-1,cumCombineData(:,1),'-r','linewidth',2,'linestyle',':'); hold on; 
plot(lengthChoice(1):lengthChoice(1)+length(cumCombineData)-1,cumCombineData(:,2),'-b','linewidth',2,'linestyle',':'); 

set(gca,'FontSize',12); ylabel('Cumulative');
legend('SWAT','Observed','Orientation','horizontal','Location','north' );
end