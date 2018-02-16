[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;


[files,path] = uigetfile([pwd,'\*.set'], 'Select the Set files', 'MultiSelect', 'on');
for i = 1:length(files)
filename = char(files(i));
EEG = pop_loadset('filename',char(files(i)),'filepath',path);
%%
%EEG = pop_runica(EEG, 'interupt','on','pca',20);
%mkdir([path,'ica again']);
[ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET); %% This has to be retained
%EEG = pop_saveset( EEG, 'filename',filename,'filepath',[path,'ica again']);
%EEG = eeg_checkset(EEG);
%eeglab redraw
%%
    for k = 10:10:80
%         if k~=10
%                     [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'retrieve',1,'study',0); 
%         end
        EEG = ALLEEG(i);
        EEG = eeg_checkset( EEG );
        EEG = pop_epoch( EEG, {  num2str(k)  }, [-0.2  0.8], 'newname', num2str(k), 'valuelim', [-300  300], 'epochinfo', 'yes');
        [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, i+1,'gui','off'); 
        EEG = eeg_checkset( EEG );
        filename = regexprep(filename, '.set', '');
        rename = [filename, ['_', num2str(k)], '.set'];
        EEG = pop_saveset( EEG, 'filename',rename,'filepath',['H:\Dhatri\normals cnt\averages set files\avg set only eye & ecg components removed\cut epoch\\',num2str(k), '\\']);
        ALLEEG = pop_delset(ALLEEG,CURRENTSET); 
    end
    
end