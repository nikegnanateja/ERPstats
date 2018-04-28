%% Custom statistics on eeglab datases
%% for eeglab


[files1, path1] = uigetfile(['H:\Dhatri\normals cnt\averages set files\avg set only eye & ecg components removed\cut epoch', '\*.set'], 'Select the first set of files', 'MultiSelect', 'on');
[files2, path2] = uigetfile(['H:\Dhatri\sttg cnt\averages set files\avg set only eye & ecg components removed\cut epoch', '\*.set'], 'Select the second set of files', 'MultiSelect', 'on');

st_ana = 0;   % Analysis start time
en_ana = 800; % Analysis end time

comparison = 2; % paired =1, unpaired =2
set_p = 0.05;  % Set the significance level for the comparisons
nboot = 2000;   % number of randomizations/reshufflings of the data
fdr = 'no'; % if FDR has to be applied 'yes' or 'no'
exclude_chns = {'M1', 'M2'};  % if no channels to have be excluded, leave the cell empty
rerefe = 'no'; %compute average rereference 'yes' or 'no'
reref_chan = {'M1', 'M2'};

if size(files1,2)~=size(files2,2)
   warning('Number of files in both conditions is not equal') 
end

col1 =[241,163,64] ;
col2 =[153,142,195] ;


col1 = col1./255;
col2 = col2./255;

clear EEG
a =[];b = [];
for i =1:size(files1,2)
    EEG = pop_loadset('filename',files1(i),'filepath',path1);

    if strcmp(rerefe,'yes')
        EEG = pop_reref(EEG,reref_chan);
        EEG = eeg_checkset(EEG);
    end
    
    if ~isempty(exclude_chns)
        EEG = pop_select(EEG,'nochannel', exclude_chns);
        EEG = eeg_checkset(EEG);
    end
    aname = eeg_checkset(EEG,'loaddata');
    a(:,:,i) = mean(aname.data,3)';
end
cond1 = EEG.condition;
clear EEG

for i =1:size(files2,2)
    EEG = pop_loadset('filename',files2(i),'filepath',path2);

    if strcmp(rerefe,'yes')
        EEG = pop_reref(EEG,reref_chan);
        EEG = eeg_checkset(EEG);
    end
    
    if ~isempty(exclude_chns)
        EEG = pop_select(EEG,'nochannel', exclude_chns);
        EEG = eeg_checkset(EEG);
    end
    
    bname = eeg_checkset(EEG,'loaddata');
    b(:,:,i) = mean(bname.data,3)';
end
cond2 = EEG.condition;

clear aname bname
% a(1:150,1:19,:) = a(1:150,1:19,:)*10; % trial to artificially increase
% the amplitude of one dataset



erp1 = mean(a,3); backuperp1 = erp1;
erp2 = mean(b,3); backuperp2 = erp2;
% Data loading stops here


%% Extracting a segment of the data for statistics
[~, st_tim] = min(abs(EEG.times-st_ana));
[~, en_tim] = min(abs(EEG.times-en_ana));


erp1 = erp1(st_tim:en_tim,:);
erp2 = erp2(st_tim:en_tim,:);

back_a = a;
back_b = b;

a = a(st_tim:en_tim,:,:);
b = b(st_tim:en_tim,:,:);


nchan = size(erp1,2);
%%
% extracting a single channel
% a = a(:,2,:);
% b = b(:,2,:);
% erp1 = mean(squeeze(a),2); erp2 = mean(squeeze(b),2);
figure; plot(erp1,'k'),hold on, plot(erp2,'r')

% means = structfun(@(a,b)fun_presamp(a,b),a,b);

% bsxfun(@fun_presamp,a,b)
% matlabpool(4)
clear pp m_error nbootcell nbootrep

tic
x = num2cell(a,3); %Collapsing each row into a single cell
y = num2cell(b,3);

%preparing the cell array for nboot
[rowboot,colboot] = size(x);
nbootrep = repmat(nboot,[rowboot,colboot]);
nbootcell = num2cell(nbootrep);

if comparison==1
    disp1 = (['Running a pairwise comparison using ' num2str(nbootcell{1}) ' randomizations']);
    disp(disp1)
    [pp,m_error] = cellfun(@fun_presamp,x,y, nbootcell);
elseif comparison==2
    disp1 = (['Running a groupwise comparison using ' num2str(nbootcell{1}) ' randomizations']);
    disp(disp1)
    %     [p(i),main_mean,mean_err,std_err, z,p_z, main_t_p, main_t, t_z, p_t_z] = cellfun(@fun_upresamp,x,y, nbootcell);
%     h = waitbar(0,'processing');
   
    m = size(a,1); n = size(a,2);
    
    % preallocating arrays
    p = zeros(m,n);main_mean= zeros(m,n);mean_err= zeros(m,n);std_err= zeros(m,n); z= zeros(m,n);p_z= zeros(m,n); main_t_p= zeros(m,n); main_t= zeros(m,n); t_z= zeros(m,n); p_t_z= zeros(m,n);
    
    for i =1 :size(a,2)
%     waitbar(i/size(a,2),h,['channel ', num2str(i) ]);
    
    parfor k = 1:size(a,1)
        
        [p(k,i),main_mean(k,i),mean_err(k,i),std_err(k,i), z(k,i),p_z(k,i), main_t_p(k,i), main_t(k,i), t_z(k,i), p_t_z(k,i), perm_t_p(k,i),perm_t_err(k,i)] = fun_upresamp(squeeze(a(k,i,:)),squeeze(b(k,i,:)), nboot);    
        
    end
    end
%     close(h)
end   
toc

pp = main_t_p; % 
if strcmp(fdr,'yes')
[row,col] = size(pp);
res_pp = reshape(pp,[],1);
% [fdr_p,pcor,padj] = fdr_cus(res_pp, set_p); pp = reshape(padj,row,col); % FDR adjusted p values, FDR calculation using Adam Winkler's Script for FDR adjustment
[~, fdr_p, ~, pp]=fdr_bh(pp,set_p,'dep','yes'); % FDR calculation using David Groppe's Script for FDR adjustment

end
%% finding continuously significant clusters in time

sr = EEG.srate;
tfs = 20; origtfs = tfs; % consecutive time-frames to threshold the pvalues in milliseconds
tfs = tfs*10^(-3); % milliseconds to seconds

nbins_o = ceil(sr*tfs);
pcell = num2cell(pp,1);
nbins = repmat(nbins_o,length(pcell),1);
nbincell = num2cell(nbins);

%preparing the p cell
[rowp,colp] = size(pcell);
set_pmat = repmat(set_p,[rowp,colp]);
set_pcell = num2cell(set_pmat);

% thresholding based on time
[clus,pdiffresh] = cellfun(@clusthr,pcell,nbincell',set_pcell,'UniformOutput', 0);
clusthresh = cell2mat(clus);

% fdr_clustr= pp; % cluster thresholded p values
% fdr_clustr(logical(clusthresh)) = 1;

%% putting the pvals and tvals back to the original time set

st_appendn = ones(st_tim-1, nchan);
en_appendn = ones(size(backuperp1,1)-en_tim, nchan);
pvalz = [st_appendn; clusthresh; en_appendn];

st_appendnt = zeros(st_tim-1, nchan);
en_appendnt = zeros(size(backuperp1,1)-en_tim, nchan);
tvalz = [st_appendnt; main_t; en_appendnt];


%% Preparing the regions for highlighting
fdr_locs = [];
for i =1:size(pvalz,2)
    pdiffresh = [];   
    pvalue = pvalz(:,i);
    pthr = zeros(length(pvalue),1); 
    pthr(pvalue<=set_p) = 1;
    
    pdiff = diff(pthr);
    pdiffind = find(pdiff);
    
    if rem(length(pdiffind),2)>0
        pdiffind(1) = [];
    end
    
    pdiffresh = [];
    pdiffresh(:,1) = 1+pdiffind(1:2:end);
    pdiffresh(:,2) = pdiffind(2:2:end);
    pdiffresh = pdiffresh';  
    pdiffresh = (pdiffresh.*(1000/EEG.srate))+(EEG.xmin*1000);
    pregions{i}= pdiffresh;    
end


%% Plotting options


erptoplot = [mean(back_a,3)', mean(back_b,3)'];
fig = figure;
set(fig, 'Color', [1 1 1])
plottopo( erptoplot, 'chanlocs', EEG.chanlocs, 'frames', EEG.pnts, ...
          'limits', [EEG.xmin EEG.xmax 0 0]*1000, 'title', 'title',  ...
          'chans', [],'legend',{''}, 'regions', pregions,  'ylim', [],  ...
          'ydir', 1, 'title', ['Plot with FDR, time based clustering at ' num2str(set_p) ' level of significance']);

      
    
%% Writing the verbose output for all the processing steps
outputfile = 'outfile.txt';

fid = fopen('outfile.txt','wt');
fprintf(fid,'%s \r\r', 'Verbose output of the Statistical comparisons');
fprintf(fid,'%s \r\r', ['comparing triggers ' cond1 ' & ' cond2]);

if strcmp(fdr, 'yes')
    fprintf(fid,'%s \r', ['p threshold = ', num2str(set_p)]);
    fprintf(fid,'%s \r', ['p  threshold FDR = ', num2str(fdr_p)]);   
end

fprintf(fid,'%s \r\r', ['Time frames for cluster thresholding (in ms) = ' num2str(origtfs)]);

fprintf(fid,'%s \r', [' ']);

fprintf(fid,'%s \r\r', ['Files in set1']);

for i = 1:size(files1,2)
fprintf(fid,'%s \r', [char(path1),char(files1(i))]); 
end
fprintf(fid,'%s \r', [' ']);

fprintf(fid,'%s \r\r', ['Files in set2']);

for i = 1:size(files2,2)
fprintf(fid,'%s \r', [char(path2),char(files2(i))]); 
end

fclose(fid)


      
%%      
%       %% STD  plot of each group;
%       avar = std(a,[],3);
%       bvar = std(b,[],3);
%       vars = [avar', bvar'];
% fig = figure;
% set(fig, 'Color', [1 1 1])
% 
% plottopo( vars, 'chanlocs', EEG.chanlocs, 'frames', EEG.pnts, ...
%           'limits', [EEG.xmin EEG.xmax 0 0]*1000, 'title', 'title', 'colors', {'r', 'b'}, ...
%           'chans', [],'legend',{''}, 'ylim', [], 'ydir', 1);
% 
%       %% plot of averages +the std
%       avar = std(a,[],3);
%       bvar = std(b,[],3);
%       vars = [avar', bvar'];
% 
%       
%       erptoplot = [erp1' erp1'+avar', erp2' erp2'+bvar',  erp1'-avar',  erp2'-bvar'];
% 
% fig = figure;
% set(fig, 'Color', [1 1 1])
% plottopo( erptoplot, 'chanlocs', EEG.chanlocs, 'frames', EEG.pnts, ...
%           'limits', [EEG.xmin EEG.xmax 0 0]*1000, 'title', 'title', 'colors', {{'r';'LineWidth';2}, {'r:';'LineWidth';0.2}, {'b';'LineWidth';2}, {'b:';'LineWidth';0.2},{'r:';'LineWidth';0.2}, {'b:';'LineWidth';0.2} }, ...
%           'chans', [],'legend',{''}, 'ylim', [], 'ydir', 1);
% 
% %% Equality of variance test plot
% tic
% x = num2cell(a,3); %Collapsing each row into a single cell
% y = num2cell(b,3);
% 
% [pp,m_error] = cellfun(@vartest2,x,y);
% toc
% 
% fig = figure;set(fig,'Color', [1 1 1])
% plottopo( m_error', 'chanlocs', EEG.chanlocs, 'frames', EEG.pnts, ...
%           'limits', [EEG.xmin EEG.xmax 0 0]*1000, 'title', 'title', 'colors', {'r'}, ...
%           'chans', [],'legend',{''}, 'ylim', [], 'ydir', 1);
      
% 
% plottopo( erptoplot, 'chanlocs', chanlocs, 'frames', pnts, ...
%           'limits', [xmin xmax 0 0]*1000, 'title', g.title, 'colors', colors, ...
%           'chans', g.chans, 'legend', legend, 'regions', regions, 'ylim', g.ylim, g.tplotopt{:});
% 
% 
% 
% 
% 
% %% Extra
% 
% 
% 
% 
% 
% % if ~isempty(idx)
% 
% % bars = axes('position',[.1  .3  .8  .01]);
% % bar(1-clusthr, 'k');
% % xlim([300 1300])
% % set(bars, 'box', 'off', 'XTick', [], 'YTick', [], 'XScale','log')
% 
% 
% 
% pthr = 1-pp(:,1); 
% pthr(pthr<0.95) = 0;
% 
% [row,col] = find(pthr);
% % M = magic(10);                 %# A 10-by-10 matrix
% % C = num2cell(M,1);             %# Collect the columns into cells
% % columnSums = cellfun(@sum,C); 