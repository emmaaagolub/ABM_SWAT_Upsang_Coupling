function [] = fun_adoptMiscanthus(workingPath, sourceFolder, filename, MISGmgtInfo)

%% Work for the new .mgt file
% delete existing file of the same filename in the destination folder
delete ([workingPath filename '.mgt'])

InputFile_mgt = [sourceFolder filename '.mgt']; % get from the source/baseline folder
OutputFile_mgt = [workingPath filename '.mgt'];

input = fopen(InputFile_mgt,'r');
output = fopen(OutputFile_mgt,'w+');
scheduleFile = fopen([MISGmgtInfo],'r');
temp = '';
%copy everything upto 'Management Operations'
while size(strfind(temp,'Management Operations:'),1) <= 0
    temp = fgets(input);
    fprintf(output,'%s',temp);
end

%copy rest from the scheduleFile
while feof(scheduleFile) == 0
    temp = fgets(scheduleFile);
    fprintf(output,'%s',temp);
end
fclose('all');


%% Work to revise the operation schedule file (.ops)
% files (we don't want filter strips in the switchgrass region -- of no
% use)
%delete the existing .ops files
delete ([workingPath filename '.ops'])

InputFile_ops = [sourceFolder filename '.ops'];
OutputFile_ops = [workingPath filename '.ops'];

ReadInputFile_ops = fileread(InputFile_ops);
DataC = strsplit(ReadInputFile_ops, '\n');
        DataC(cellfun('isempty', DataC)) = [];
        S1= DataC{1}; % just read the first line to ge the header info only
        % fill-in the contents of .ops file for the output
        fileID = fopen (OutputFile_ops, 'w');
        
                                S2 = '  1  1     2020  4    0      51.30      0.50000   0.00'; % insert the FS in the second line with 0 FLAG-Inactive
                                fprintf(fileID,'%s\n',S1); %print the first line
                                fprintf(fileID,'%s\n',S2); % This line adds filter strips (FS) but switches off with 0 (done for consistency across the data files)
%                             fprintf(fileID, '%s\n', DataC{2:end}); % This
%                             line is not required since we dont need HI
%                             and LAI information for Corn and Soy
%                             
                                fclose(fileID);
