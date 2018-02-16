clear;clc
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
[files,path] = uigetfile(['H:\\Dhatri\\sttg cnt\\averages set files\\avg set only eye & ecg components removed\\cut epoch\\80\\after dipfit\\','\*.set'], 'Select the Set files', 'MultiSelect', 'on');
n = length(files);

for i = 1:n
    filename = char(files(i));
EEG = pop_loadset('filename',char(files(i)),'filepath',path);
[ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
EEG = eeg_checkset( EEG );
EEG=pop_chanedit(EEG, 'load',{'H:\\Dhatri\\62.ced' 'filetype' 'autodetect'});
[ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
EEG = pop_saveset( EEG, 'savemode','resave');
[ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
clear EEG
end
