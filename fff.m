%% for thresholding the p values in the topoplot based on spatial cluster

clustoplot = 1; % cluster to plot, clusters are arranged in the descending order of the number of channels in each cluster


inds = selectchan{clustoplot};
blankp = zeros(2,0);
for i =1:nchan
    pnewcell{i} = blankp;
end

for i = 1:length(inds)
    k = inds(i);
    time = find(clust_membership(k,:)==sortind(clustoplot));
    time_corr = EEG.times(st_tim-1+time);
    pnewcell{k} = [time_corr(1); time_corr(length(time_corr))] ;
end
    [row,col] = find(clust_membership ==clustoplot);



% 
% clus_pregions = pregions;
% inds = selectchan{clustoplot};
% for i = 1:size(clus_pregions,2)
%     if length(selectchan{clustoplot})<=min_n
%     clus_pregions{i} = zeros(2,0);
%     elseif ~ismember(i, inds)
%     clus_pregions{i} = zeros(2,0);
%     end
% end
if selectchan{clustoplot}>=min_n
disp(['None of the clusters have significant differences in more than or equal to ' num2str(min_n) ' channels'])
end

fig = figure;
set(fig, 'Color', [1 1 1])
plottopo( erptoplot, 'chanlocs', EEG.chanlocs, 'frames', EEG.pnts, ...
          'limits', [EEG.xmin EEG.xmax 0 0]*1000, 'title', 'title', ...
          'chans', [],'legend',{''}, 'regions', pnewcell,  'ylim', [], ...
          'ydir', 1, 'title', ['Plot with FDR, time and space based clustering at ' num2str(set_p) ' level of significance']);

      
      