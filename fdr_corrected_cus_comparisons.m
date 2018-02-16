%% Custom statistics on eeglab datases
%% for eeglab


[files1, path1] = uigetfile(['H:\Dhatri\normals cnt\averages set files\avg set only eye & ecg components removed\cut epoch', '\*.set'], 'Select the first set of files', 'MultiSelect', 'on');
[files2, path2] =  uigetfile(['H:\Dhatri\sttg cnt\averages set files\avg set only eye & ecg components removed\cut epoch', '\*.set'], 'Select the second set of files', 'MultiSelect', 'on');

if size(files1,2)~=size(files2,2)
   warning('Number of files in both conditions is not equal') 
end
a =[];b = [];
for i =1:size(files1,2)
EEG = pop_loadset('filename',files1(i),'filepath',path1);
aname = eeg_checkset(EEG,'loaddata');
a(:,:,i) = mean(aname.data,3)';
bname = pop_loadset('filename',files2(i),'filepath',path2);
b(:,:,i) = mean(bname.data,3)';
end
erp1 = mean(a,3);
erp2 = mean(b,3);
%% Data loading stops here





% extracting a single channel
% a = a(:,2,:);
% b = b(:,2,:);
% erp1 = mean(squeeze(a),2); erp2 = mean(squeeze(b),2);
figure; plot(erp1,'k'),hold on, plot(erp2,'r')

% means = structfun(@(a,b)fun_presamp(a,b),a,b);

% bsxfun(@fun_presamp,a,b)
% matlabpool(4)
clear pp m_error
tic
x = num2cell(a,3); %Collapsing each row into a single cell
y = num2cell(b,3);

[pp,m_error] = cellfun(@fun_upresamp,x,y);
toc
origpp = pp;
[row,col] = size(pp);
res_pp = reshape(pp,[],1);
[fdr_p,pcor,padj] = fdr_cus(res_pp); %% FDR calculation
pp = reshape(padj,row,col);

%% finding continuously significant clusters in time
sr = EEG.srate;
tfs = 20;%in milliseconds
tfs = tfs*10^(-3); %in milliseconds

nbins = ceil(sr*tfs);
pcell = num2cell(pp,1);
nbins = repmat(nbins,length(pcell),1);
nbincell = num2cell(nbins);
[clus,pdiffresh] = cellfun(@clusthr,pcell,nbincell','UniformOutput', 0);
clusthresh = cell2mat(clus);

%% FDR thresholding based on Benjamini and Hochberg Procedure


% plist = clusthresh(:);
% [fdr_p,pcor,padj] = fdr(plist);


fdr_clustr= clusthresh;

%% Preparing the regions for highlighting
pvalz = fdr_clustr;
fdr_locs = [];
for i =1:size(fdr_clustr,2)
 pdiffresh = [];   
    pvalue = pvalz(:,i);
pthr = zeros(length(pvalue),1); 
pthr(pvalue<=0.05) = 1;
   
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


erptoplot = [mean(a,3)', mean(b,3)'];
fig = figure;
set(fig, 'Color', [1 1 1])
plottopo( erptoplot, 'chanlocs', EEG.chanlocs, 'frames', EEG.pnts, ...
          'limits', [EEG.xmin EEG.xmax 0 0]*1000, 'title', 'title', 'colors', {'r', 'b'}, ...
          'chans', [],'legend',{''}, 'regions', pregions,  'ylim', [], 'ydir', 1);

      
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