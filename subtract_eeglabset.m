[files1, path1] = uigetfile(['H:\Dhatri\sttg cnt\averages set files\avg set only eye & ecg components removed\cut epoch\', '\*.set'], 'Select the first set of files', 'MultiSelect', 'on');
[files2, path2] =  uigetfile(['H:\Dhatri\sttg cnt\averages set files\avg set only eye & ecg components removed\cut epoch', '\*.set'], 'Select the second set of files', 'MultiSelect', 'on');

outputdir = 'H:\Dhatri\sttg cnt\averages set files\avg set only eye & ecg components removed\cut epoch\';

if size(files1,2)~=size(files2,2)
   warning('Number of files in both conditions is not equal') 
   
else

%% Checking the trigger number of both the 
check1 = char(files1(1));
filext1 = check1(end-5:end-4);
check2 = char(files2(1));
filext2 = check2(end-5:end-4);
outdir = [filext1, '-', filext2];
outfiledir = [outputdir,'sub_',outdir ];
if ~exist(outfiledir)
mkdir(outfiledir)
end


disp(['performing subtraction of triggers ',  filext1, '-', filext2]) 
%%
a =[];b = [];
eeglab('nogui')
for i =1:size(files1,2)
EEG = [];
EEG = pop_loadset('filename',files1(i),'filepath',path1);
aname = eeg_checkset(EEG,'loaddata');
a = mean(aname.data,3)';
bname = pop_loadset('filename',files2(i),'filepath',path2);
b = mean(bname.data,3)';

meandiff = a'-b';
EEG.data = repmat(meandiff,[1,1,size(EEG.data,3)]);


 EEG = pop_saveset(EEG, 'filename',  [char(files1(i)),' - ' char(files2(i))],  'filepath', outfiledir, 'savemode', 'onefile');



end


end
