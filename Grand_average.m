[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;

[files,path] = uigetfile(['H:\Dhatri\normals cnt\averages set files\avg set only eye & ecg components removed\cut epoch','\*.set'], 'Select the Set files', 'MultiSelect', 'on');
n = length(files);
for i = 1:n
EEG = pop_loadset('filename',char(files(i)),'filepath',path);
[ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
if i==2, urchan = [ALLEEG(2).chanlocs.urchan];else urchan = [ALLEEG(i).chanlocs.urchan]; end
x = ALLEEG(i).data;
x_mean = mean(x,3);
x_mean =  x_mean(urchan,:);
y(:,:,i) = x_mean;
end

g_avg = mean(y,3);
ALLEEG(n+1) = ALLEEG(2);
ALLEEG(n+1).data = g_avg;
ALLEEG(n+1).trials = 1; 
ALLEEG(n+1).icaact = [];
ALLEEG(n+1).icawinv = [];
ALLEEG(n+1).icasphere = [];
ALLEEG(n+1).icaweights = [];
ALLEEG(n+1).icachansind = [];
ALLEEG(n+1).event = ALLEEG(n+1).event(1);
ALLEEG(n+1).epoch = ALLEEG(n+1).epoch(1);
ALLEEG(n+1) = eeg_checkset(ALLEEG(n+1));
ALLEEG(n+1).filename = 'Grand Average';
ALLEEG(n+1).setname = 'Grand average';
eeglab redraw 
