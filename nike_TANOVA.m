%% Custom statistics on eeglab datases
%% for eeglab

eeglab('nogui')
[files1, path1] = uigetfile(['H:\Dhatri\sttg cnt\averages set files\avg set only eye & ecg components removed\cut epoch', '\*.set'], 'Select the first set of files', 'MultiSelect', 'on');
[files2, path2] =  uigetfile(['H:\Dhatri\sttg cnt\averages set files\avg set only eye & ecg components removed\cut epoch', '\*.set'], 'Select the second set of files', 'MultiSelect', 'on');

if size(files1,2)~=size(files2,2)
   warning('Number of files in both conditions is not equal') 
end
a =[];b = [];
for i =1:size(files1,2)
EEG = pop_loadset('filename',files1(i),'filepath',path1);
aname = eeg_checkset(EEG,'loaddata');
data1 = mean(aname.data,3)';
data1_avref = data1-repmat(mean(data1,2), [1,size(data1,2)]);
gfp1 = std(data1_avref,[],2);
data1norm = data1_avref./repmat(gfp1,[1,size(data1_avref,2)]);

cond1norm(:,:,i) = data1norm;
cond1_averef(:,:,i) = data1_avref;

a(:,:,i) = data1norm;
origa(:,:,i) = data1;

bname = pop_loadset('filename',files2(i),'filepath',path2);
data2 = mean(bname.data,3)';
data2_avref = data2-repmat(mean(data2,2), [1,size(data2,2)]);
gfp2 = std(data2_avref,[],2);
data2norm = data2_avref./repmat(gfp2,[1,size(data2_avref,2)]);

cond2norm(:,:,i) = data2norm;
cond2_averef(:,:,i) = data2_avref;

b(:,:,i) = data2norm;
origb(:,:,i) = data2;
end
%% Data loading stops here
clear pp m_error

p =[]; mean_error = [];
for i = 1:size(a,1)
[p(i),mean_error(i)] = fun_presamp_TANOVA(squeeze(a(i,:,:)),squeeze(b(i,:,:)));
end

erp1 = mean(origa,3);
erp2 = mean(origb,3);

pp = p;
% extracting a single channel
% a = a(:,2,:);
% b = b(:,2,:);
% erp1 = mean(squeeze(a),2); erp2 = mean(squeeze(b),2);
% figure; plot(erp1,'k'),hold on, plot(erp2,'r')

% means = structfun(@(a,b)fun_presamp(a,b),a,b);

% bsxfun(@fun_presamp,a,b)
% matlabpool(4)

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
[clus,pdiffresh] = clusthr(pp,nbins);
clusthresh = clus;

figure
plot(EEG.times,erp1,'k', EEG.times,erp2,'r')
hold on
plot(EEG.times,1-clus,'b', 'LineWidth', 2)
% plot(EEG.times,1-origpp,'gx','LineWidth',3)
% line(EEG.times,repmat(0.95,[length(origpp),1]))
%% FDR thresholding based on Benjamini and Hochberg Procedure


% plist = clusthresh(:);
% [fdr_p,pcor,padj] = fdr(plist);

% figure;timtopo(erp1',EEG.chanlocs);
% figure;timtopo(erp2',EEG.chanlocs);
% 
% figure;timtopo(mean(cond1norm,3)', EEG.chanlocs)
% figure;timtopo(mean(cond2norm,3)', EEG.chanlocs)
% 
% figure;timtopo(mean(cond1_averef,3)', EEG.chanlocs)
% figure;timtopo(mean(cond2_averef,3)', EEG.chanlocs)
% 
% %% Plotting options
% 
% 
% erptoplot = [mean(origa,3)', mean(origb,3)'];
% fig = figure;
% set(fig, 'Color', [1 1 1])
% plottopo( erptoplot, 'chanlocs', EEG.chanlocs, 'frames', EEG.pnts, ...
%           'limits', [EEG.xmin EEG.xmax 0 0]*1000, 'title', 'title', 'colors', {'r', 'b'}, ...
%           'chans', [],'legend',{''},  'ylim', [], 'ydir', 1);

      
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