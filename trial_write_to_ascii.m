
clear;clc
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
[files,path] = uigetfile(['H:\\Dhatri\\normals cnt\\averages set files\\avg set only eye & ecg components removed\\cut epoch\\80\\after dipfit','\*.set'], 'Select the Set files', 'MultiSelect', 'on');
outputdir = uigetdir('H:\\Dhatri\\normals cnt\\averages set files\\avg set only eye & ecg components removed\\cut epoch\\80\\after dipfit\\ascii files 30 sttg\\', 'Select the outputdir');
n = length(files);

for i = 1:n
    filename = char(files(i));
EEG = pop_loadset('filename',char(files(i)),'filepath',path);
outputfilename = regexprep(filename, '.set', '');
pop_export(EEG,[outputfilename '.dat'],[outputdir '\'],'erp','on','transpose','on','time','off','precision',4);
clear EEG
end

