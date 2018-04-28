cluster_thresh = ones(size(clust_membership));

cluster_thresh(clust_membership==sortind(clustoplot)) = 0;
clusthrcell = num2cell(cluster_thresh',1);
[cluus,cluusids] = cellfun(@clusthr,clusthrcell,nbincell',set_pcell,'UniformOutput', 0);
cluus = cell2mat(cluus);
backkk = cluus;
cluus(backkk==0) = 1;
cluus(backkk==1) = 0;
back_cluus = cluus;

st_appendnt = zeros(st_tim-1, nchan);
en_appendnt = zeros(size(backuperp1,1)-en_tim, nchan);

cluus = [st_appendnt; cluus; en_appendnt];


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


t_cluster = sum(abs(main_t(logical(back_cluus))));

% count the number of channels with significant clusters
cc = 1;
perma = {};
permb = {};
for i = 1:nchan
    chancount(i) = ~isempty(pregions{i});
   if ~isempty(pregions{i})
       
       tmpa = squeeze(a(:,i,:));
       tmpb = squeeze(b(:,i,:));
    
       perma{cc} = tmpa(logical(back_cluus(:,i)),:);
       permb{cc}  = tmpb(logical(back_cluus(:,i)),:);
       
       cc =cc+1;
   end
end

loops = 1;
while loops<=nboot
    resampt = [];
for i = 1:length(perma)
    samp1 = perma{i};
    samp2 = permb{i};
    tmpresamp_t = [];
    for k = 1:size(samp1,1)
        tmpresamp_t(k) = fun_upresamp4clust(samp1(k,:)',samp2(k,:)',1);
        disp(['k=', num2str(k)])
    end
    resampt = [resampt,tmpresamp_t];
    disp(['i=', num2str(k)])
   
end
perm_sum_t(loops) = sum(abs(resampt));

loops = loops+1;
end

figure;histfit(perm_sum_t,100)
hold on
plot(t_cluster,0,'rx', 'MarkerSize',30)


t_clustcell = repmat(t_cluster,length(perma),1);
t_clustcell = num2cell(t_clustcell);


% [~,main_mean(k,i),mean_err(k,i),std_err(k,i), z(k,i),p_z(k,i), main_t_p(k,i), main_t(k,i), t_z(k,i), p_t_z(k,i), perm_t_p(k,i),perm_t_err(k,i)] = fun_upresamp(squeeze(a(k,i,:)),squeeze(b(k,i,:)), nboot);    

% erptoplot = [mean(back_a,3)', mean(back_b,3)'];
% fig = figure;
% set(fig, 'Color', [1 1 1])
% plottopo( erptoplot, 'chanlocs', EEG.chanlocs, 'frames', EEG.pnts, ...
%           'limits', [EEG.xmin EEG.xmax 0 0]*1000, 'title', 'title',  ...
%           'chans', [],'legend',{''}, 'regions', pregions,  'ylim', [],  ...
%           'ydir', 1, 'title', ['Plot with FDR, time based clustering at ' num2str(set_p) ' level of significance']);

      
      
      