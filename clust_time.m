%% for thresholding the p values in the topoplot based on spatial cluster

clustoplot = 1; % cluster to plot, clusters are arranged in the descending order of the number of channels in each cluster


inds = selectchan{clustoplot};
cluster_thresh = clust_membership;
cluster_thresh(clust_membership~=sortind(clustoplot)) = 1;
cluster_thresh(clust_membership==sortind(clustoplot)) = 0;
% clusthrcell = num2cell(cluster_thresh',1);
% [cluus,cluusids] = cellfun(@clusthr,clusthrcell,nbincell',set_pcell,'UniformOutput', 0);

st_appendnt = zeros(st_tim-1, nchan);
en_appendnt = zeros(size(backuperp1,1)-en_tim, nchan);
cluus = [st_appendnt; (cluster_thresh)'; en_appendnt];


pregions = {};
for i =1:size(cluus,2)
    pthr = cluus(:,i); 
    
    
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


erptoplot = [mean(back_a,3)', mean(back_b,3)'];
fig = figure;
set(fig, 'Color', [1 1 1])
plottopo( erptoplot, 'chanlocs', EEG.chanlocs, 'frames', EEG.pnts, ...
          'limits', [EEG.xmin EEG.xmax 0 0]*1000, 'title', 'title',  ...
          'chans', [],'legend',{''}, 'regions', pregions,  'ylim', [],  ...
          'ydir', 1, 'title', ['Plot with FDR, time based clustering at ' num2str(set_p) ' level of significance']);

if selectchan{clustoplot}>=min_n
disp(['None of the clusters have significant differences in more than or equal to ' num2str(min_n) ' channels'])
end


      
      
      

      
      