
tic
% Create Stern STUDY
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
pop_editoptions( 'option_storedisk', 1);

pathN = 'H:\Dhatri\normals cnt\averages set files\avg set only eye & ecg components removed';
[files1, path1] = uigetfile([pathN '\*.set'], 'MultiSelect', 'on');
normal = files1;

pathS = 'H:\Dhatri\sttg cnt\averages set files\avg set only eye & ecg components removed';
[files2, path2] = uigetfile([pathS '\*.set'], 'MultiSelect', 'on');
stutt = files2;




filepath1 = pathN; % XXXXX Change path here XXXXX
filepath2 = pathS;enf
if ~exist(filepath1), error('You need to change the path to the STUDY'); end;
if ~exist(filepath2), error('You need to change the path to the STUDY'); end;

commands = {}; % initialize STUDY dataset list
% Loop through all of the subjects in the study to create the dataset

triggers = 10:10:80;

for loopnum = 1:length(normal) %for each subject

% Normals    
N10File = fullfile(pathN, num2str(triggers(1)), 'after dipfit', normal{loopnum}); 
N20File = fullfile(pathN, num2str(triggers(2)), 'after dipfit', regexprep(normal{loopnum},'10.set',[num2str(triggers(2)), '.set']));
N30File = fullfile(pathN, num2str(triggers(3)), 'after dipfit', regexprep(normal{loopnum},'10.set',[num2str(triggers(3)), '.set']));
N40File = fullfile(pathN, num2str(triggers(4)), 'after dipfit', regexprep(normal{loopnum},'10.set',[num2str(triggers(4)), '.set']));
N50File = fullfile(pathN, num2str(triggers(5)), 'after dipfit', regexprep(normal{loopnum},'10.set',[num2str(triggers(5)), '.set']));
N60File = fullfile(pathN, num2str(triggers(6)), 'after dipfit', regexprep(normal{loopnum},'10.set',[num2str(triggers(6)), '.set']));
N70File = fullfile(pathN, num2str(triggers(7)), 'after dipfit', regexprep(normal{loopnum},'10.set',[num2str(triggers(7)), '.set']));
N80File = fullfile(pathN, num2str(triggers(8)), 'after dipfit', regexprep(normal{loopnum},'10.set',[num2str(triggers(8)), '.set']));


commands = {commands{:} ...
{'index' 8*loopnum-7 'load' N10File 'subject' regexprep(normal{loopnum}, '_10.set', '') 'condition' '10' 'group' 'Normal'} ...
{'index' 8*loopnum-6 'load' N20File 'subject' regexprep(normal{loopnum}, '_10.set', '') 'condition' '20' 'group' 'Normal'} ...
{'index' 8*loopnum-5 'load' N30File 'subject' regexprep(normal{loopnum}, '_10.set', '') 'condition' '30' 'group' 'Normal'} ...
{'index' 8*loopnum-4 'load' N40File 'subject' regexprep(normal{loopnum}, '_10.set', '') 'condition' '40' 'group' 'Normal'} ...
{'index' 8*loopnum-3 'load' N50File 'subject' regexprep(normal{loopnum}, '_10.set', '') 'condition' '50' 'group' 'Normal'} ...
{'index' 8*loopnum-2 'load' N60File 'subject' regexprep(normal{loopnum}, '_10.set', '') 'condition' '60' 'group' 'Normal'} ...
{'index' 8*loopnum-1 'load' N70File 'subject' regexprep(normal{loopnum}, '_10.set', '') 'condition' '70' 'group' 'Normal'} ...
{'index' 8*loopnum   'load' N80File 'subject' regexprep(normal{loopnum}, '_10.set', '') 'condition' '80' 'group' 'Normal'}};

end;
next_start = 8*loopnum;
for loopnum = 1:length(stutt) %for each subject

% Stutterers
S10File = fullfile(pathS, num2str(triggers(1)), 'after dipfit', stutt{loopnum}); 
S20File = fullfile(pathS, num2str(triggers(2)), 'after dipfit', regexprep(stutt{loopnum},'10.set',[num2str(triggers(2)), '.set']));
S30File = fullfile(pathS, num2str(triggers(3)), 'after dipfit', regexprep(stutt{loopnum},'10.set',[num2str(triggers(3)), '.set']));
S40File = fullfile(pathS, num2str(triggers(4)), 'after dipfit', regexprep(stutt{loopnum},'10.set',[num2str(triggers(4)), '.set']));
S50File = fullfile(pathS, num2str(triggers(5)), 'after dipfit', regexprep(stutt{loopnum},'10.set',[num2str(triggers(5)), '.set']));
S60File = fullfile(pathS, num2str(triggers(6)), 'after dipfit', regexprep(stutt{loopnum},'10.set',[num2str(triggers(6)), '.set']));
S70File = fullfile(pathS, num2str(triggers(7)), 'after dipfit', regexprep(stutt{loopnum},'10.set',[num2str(triggers(7)), '.set']));
S80File = fullfile(pathS, num2str(triggers(8)), 'after dipfit', regexprep(stutt{loopnum},'10.set',[num2str(triggers(8)), '.set']));

commands = {commands{:} ...
{'index' next_start+8*loopnum-7 'load' S10File 'subject' regexprep(stutt{loopnum}, '_10.set', '') 'condition' '10' 'group' 'Stutt'} ...
{'index' next_start+8*loopnum-6 'load' S20File 'subject' regexprep(stutt{loopnum}, '_10.set', '') 'condition' '20' 'group' 'Stutt'} ...
{'index' next_start+8*loopnum-5 'load' S30File 'subject' regexprep(stutt{loopnum}, '_10.set', '') 'condition' '30' 'group' 'Stutt'} ...
{'index' next_start+8*loopnum-4 'load' S40File 'subject' regexprep(stutt{loopnum}, '_10.set', '') 'condition' '40' 'group' 'Stutt'} ...
{'index' next_start+8*loopnum-3 'load' S50File 'subject' regexprep(stutt{loopnum}, '_10.set', '') 'condition' '50' 'group' 'Stutt'} ...
{'index' next_start+8*loopnum-2 'load' S60File 'subject' regexprep(stutt{loopnum}, '_10.set', '') 'condition' '60' 'group' 'Stutt'} ...
{'index' next_start+8*loopnum-1 'load' S70File 'subject' regexprep(stutt{loopnum}, '_10.set', '') 'condition' '70' 'group' 'Stutt'} ...
{'index' next_start+8*loopnum   'load' S80File 'subject' regexprep(stutt{loopnum}, '_10.set', '') 'condition' '80' 'group' 'Stutt'}};
end



% Uncomment the line below to select ICA components with less than 15% residual variance
% commands = {commands{:} {'dipselect', 0.15}};
[STUDY, ALLEEG] = std_editset(STUDY, ALLEEG, 'name','AV all conditions','commands',commands,'updatedat','on');
% Update workspace variables and redraw EEGLAB
CURRENTSTUDY = 1; EEG = ALLEEG; CURRENTSET = [1:length(EEG)];
[STUDY, ALLEEG] = std_checkset(STUDY, ALLEEG);
eeglab redraw
toc
