min_n = 4; % minimum number of electrodes in a cluster to be considered important

chan_hood=spatial_neighbors(EEG.chanlocs,4, 10);
figure;imagesc(chan_hood)

[clust_membership, n_clust]=find_clusters(pp',set_p,chan_hood,1);

figure;imagesc(clust_membership), 
caxis([0 n_clust]);cb = colorbar; cb.Ticks = 1:n_clust;cb.TickLabels = num2cell(1:n_clust);

disp(['number of clusters = ', num2str(n_clust)])

% calculating the channels per cluster
selectchan = {};
nclusters = [];
selecttime = {};
for i = 1:n_clust
    row =[];col=[];
    [row,col] = find(clust_membership ==i);
    [selectchan{i} times] = unique(row,'sorted');   
    nclusters(i) = size(selectchan{i},1);
end

%  new=pop_chanedit(EEG, 'eval','chans = pop_chancenter( chans, [],[33 43] );');
%  figure;topoplot([],new.chanlocs,'plotrad', 1,'headrad', 0.6,'emarker', {'o','r',5,2}, 'style', 'electrodes', 'plotdisk', 'on')

% for n=1:length(new.chanlocs)
%     new.chanlocs(1,n).radius = new.chanlocs(1,n).radius*0.95;
% end
[nclusters, sortind] = sort(nclusters,2,'descend');
selectchan = selectchan(sortind);

nn = size(nclusters,2);
if nn>3
    nn=3;
end

figure
for i = 1:nn
    subplot(1,nn, i), topoplot([],EEG.chanlocs,'plotchans', selectchan{i},'plotrad', 1,'headrad', 0.6,'emarker', {'o','r',5,2}, 'style', 'electrodes', 'plotdisk', 'on')
    title(['cluster number ' , num2str(i)])
end


