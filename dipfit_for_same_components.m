clear;clc
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
[files,path] = uigetfile(['H:\Dhatri\sttg cnt\averages set files\avg set only eye & ecg components removed\80','\*.set'], 'Select the Set files', 'MultiSelect', 'on');
outputdir = uigetdir('H:\Dhatri\sttg cnt\averages set files\avg set only eye & ecg components removed\80\after dipfit', 'Select the outputdir');
n = length(files);

for i = 1:n
    filename = char(files(i));
EEG = pop_loadset('filename',char(files(i)),'filepath',path);
[ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
EEG = eeg_checkset( EEG );
EEG = pop_dipfit_settings( EEG, 'hdmfile','H:\\Dhatri\\eeglab14_1_1b\\eeglab14_1_1b\\plugins\\dipfit2.3\\standard_BEM\\standard_vol.mat','coordformat','MNI','mrifile','H:\\Dhatri\\eeglab14_1_1b\\eeglab14_1_1b\\plugins\\dipfit2.3\\standard_BEM\\standard_mri.mat','chanfile','H:\\Dhatri\\eeglab14_1_1b\\eeglab14_1_1b\\plugins\\dipfit2.3\\standard_BEM\\elec\\standard_1005.elc','coord_transform',[0.63172 -17.0114 -1.2333 0.067181 -0.010132 -1.617 9.7807 10.7743 11.2918] ,'chansel',[1:62] );
[ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
EEG = pop_multifit(EEG, [1:60] ,'threshold',100,'rmout','on','dipoles',2,'plotopt',{'normlen' 'on'});
[ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
outputfilename = regexprep(filename, '.set', '');
EEG = pop_saveset( EEG, 'filename',[outputfilename '.set'],'filepath',[outputdir '\'] );
clear EEG
end