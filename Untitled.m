[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
EEG = pop_loadset('filename','Adarsh.set','filepath','H:\\Dhatri\\sttg cnt\\after ica\\pruned with ica\\');
[ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
EEG = eeg_checkset( EEG );
% EEG = pop_runica(EEG, 'interupt','on','pca',25);
[ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
EEG = eeg_checkset( EEG );
EEG = pop_saveset( EEG, 'savemode','resave');
[ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'retrieve',1,'study',0); 
EEG = eeg_checkset( EEG );
EEG = pop_epoch( EEG, {  '10'  }, [-1  2], 'newname', '10', 'valuelim', [-100  100], 'epochinfo', 'yes');
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'gui','off'); 
EEG = eeg_checkset( EEG );
EEG = pop_saveset( EEG, 'filename','Adarsh_10.set','filepath','H:\\Dhatri\\sttg cnt\\averages set files\\avg set after pruned with ica\\10\\');
[ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 2,'retrieve',1,'study',0); 
EEG = eeg_checkset( EEG );
EEG = pop_epoch( EEG, {  '20'  }, [-1  2], 'newname', '20', 'valuelim', [-100  100], 'epochinfo', 'yes');
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'gui','off'); 
EEG = eeg_checkset( EEG );
EEG = pop_saveset( EEG, 'filename','Adarsh_20.set','filepath','H:\\Dhatri\\sttg cnt\\averages set files\\avg set after pruned with ica\\20\\');
[ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);