 function [YieldTable_HRUscale, YieldTable_SubbasinScale] = fun_extract_crop_yield_extended (filename_mgt)

%% Read the Output.mgt file in MATLAB and extract the crop yeild information

Data  = fileread(filename_mgt);
DataC = strsplit(Data, '\n');
DataC(cellfun('isempty', DataC)) = [];

nLine   = numel(DataC);
...
    c1=0;
for iLine = 6:nLine % First 5 is the header
  
c1=c1+1;
  S              = DataC{iLine};
  Sub(c1,1)    = sscanf(S(4:5), '%d');  % Subbasin 
  Hru(c1,1)= sscanf(S(9:10), '%d');  % HRU
  Year(c1,1) = sscanf(S(13:17),'%d'); % Year
  Mon(c1,1) = sscanf(S(21:22),'%d'); % Mon
  Day(c1,1) = sscanf(S(26:28),'%d'); % Day
  Area(c1,1) = sscanf(S(30:39),'%f'); % HRU Area
 
  if isempty(sscanf(S(48:55),'%s'))
  CFP{c1,1} =NaN;
  else
 CFP{c1,1} = sscanf(S(48:55),'%s'); % crop fert pest THIS is TEXT
  end
  
  if isempty(sscanf(S(59:70),'%s'))
       OPR{c1,1} = NaN;
  else
  OPR{c1,1} = sscanf(S(59:70),'%s'); % Operation THIS is TEXT
  end
  
  % check the data length
  
  if numel(S)>143
  
               if  isempty(sscanf(S(143:150),'%f'))
                   Yeild(c1,1) = NaN;
             else
                   Yeild(c1,1) =  sscanf(S(143:150),'%f'); % crop fert pest
             end
  else
            Yeild(c1,1) = NaN;
  end
  end

CropYeild = table(Sub,Hru,Year,Mon,Day,Area,CFP,OPR,Yeild); % this is all essential info from output.mgt

firstYear = CropYeild.Year(1);
endYear =CropYeild.Year(end);

%% Create dataframe to extract annual yeild information

% select the harvest/kill operation first to minimize the computation 
YieldTable_HRUscale=CropYeild(ismember(CropYeild.OPR,{'HARVESTONLY','HARV/KILL'}),:); % considering both here

% define a function that can extract the yield at the subbasin scale
function [yield_sub_avg, area] = calculateCropMetrics(cropCode, data)
    % Extract crop information
    crop_table = data(ismember(data.CFP, cropCode), :);
    
    if isempty(crop_table)
        yield_sub_avg = 0;
        area = 0;
    else
        yield_sub_avg = sum(crop_table.Area .* crop_table.Yeild) / sum(crop_table.Area);
        area = sum(crop_table.Area);
    end
end

% select year and subbasin : this is where we put for loop
xx=0;
for years = firstYear:endYear
    for sub_basin =1:45
        xx=xx+1;
        rows = (YieldTable_HRUscale.Sub==sub_basin & YieldTable_HRUscale.Year==years);
        Subbsn_Yr_Yield=YieldTable_HRUscale(rows,:);
        
        % the crop code from the plant.dat 
        [Yield_Corn_sub_avg, AreaofCorn] = calculateCropMetrics('CRFS', Subbsn_Yr_Yield);
        [Yield_Soyb_sub_avg, AreaofSoy] = calculateCropMetrics('SYFS', Subbsn_Yr_Yield);
        [Yield_CSIL_sub_avg, AreaofCSIL] = calculateCropMetrics('CSIL', Subbsn_Yr_Yield); % this is corn silage; only adopted in subbasin 8 for the stone ridge dairy farm
        [Yield_MISG_sub_avg, AreaofMISG] = calculateCropMetrics('MISG', Subbsn_Yr_Yield);
        [Yield_SWSH_sub_avg, AreaofSWSH] = calculateCropMetrics('SWSH', Subbsn_Yr_Yield); 
        
        %store the above values here
        Final_Crop_Yeild_data_withCroplandArea(xx,:)=[sub_basin years ... 
            Yield_Corn_sub_avg Yield_Soyb_sub_avg Yield_CSIL_sub_avg  Yield_MISG_sub_avg Yield_SWSH_sub_avg ...
            AreaofCorn AreaofSoy AreaofCSIL AreaofMISG AreaofSWSH];
        
    end
    
end

% create a table of the above results
YieldTable_SubbasinScale = array2table(Final_Crop_Yeild_data_withCroplandArea, "VariableNames", {'Subbasin', 'Year', ...
    'CornYield_kg_ha','SoyYield_kg_ha','CornSilageYield_kg_ha','MiscanthusYield_kg_ha','SwitchgrassYield_kg_ha',...
    'AreaCorn_km2','AreaSoy_km2','AreaCornSilage_km2','AreaMiscanthus_km2','AreaSwitchgrass_km2'});
    
 end % end of the large function        
        
        
        
   