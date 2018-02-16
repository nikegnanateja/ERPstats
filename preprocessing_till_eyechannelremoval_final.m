[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
[files,path] = uigetfile(['F:\thesis data\data\EP\continuous data\normals','\','*.cnt'], 'Select all the files to process','MultiSelect','on');
n = size(files,2);
outputdir = uigetdir('F:\thesis data\data\EP\continuous data\normals\eeglab preprocessed\downsample, filter,channel info,eye channel removed', 'Select the outputdir');
for i =1:n
    
    filename = [path char(files(:,i))];
    outputfilename = regexprep(char(files(:,i)), '.cnt','');
EEG = pop_loadcnt(filename, 'dataformat', 'auto', 'memmapfile', '');
EEG = pop_select( EEG,'nochannel',{'HEOG' 'VEOG' 'CB1' 'CB2'});
EEG=pop_chanedit(EEG, 'lookup','F:\\thesis data\\data\\EP\\62_no HEOG VEOG CB1 CB2.xyz','eval','chans = pop_chancenter( chans, [],[]);');
EEG = pop_eegfiltnew(EEG, [], 1, [], true, [], 0);
EEG = pop_eegfiltnew(EEG, [], 30, [], 0, [], 0);
EEG = pop_resample( EEG, 256);
EEG = pop_saveset( EEG, 'filename',[outputfilename '.set'],'filepath',[outputdir '\'] );
clear EEG
end