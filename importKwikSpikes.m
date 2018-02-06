function [spiketimes, clusters, clusterQuality]=importKwikSpikes(kwikfile)
%IMPORTKWIKSPIKES Takes a .kwik file (from kwik-gui), and returns all the spike times, their cluster number, and the clusterQuality (0=noise, 1=MUA, 2=Single Unit).
% [spiketimes, clusters, clusterQuality]=importKwikSpikes(kwikfile)
spiketimes=h5read(kwikfile, '/channel_groups/0/spikes/time_samples');

clusters=hdf5read(kwikfile, '/channel_groups/0/spikes/clusters/main');


% Get Cluster Group attribute
groups=unique(clusters');
for i=groups
  clusterQuality(i+1)=h5readatt(kwikfile, ['/channel_groups/0/clusters/main/',int2str(i)],   'cluster_group');

end

% disp(clusterQuality');

%Number of Clusters
numberOfClusters=max(clusters)+1;

disp(['There are ', int2str(length(spiketimes)), ' Spikes in ', int2str(numberOfClusters), ' clusters.']);

disp(['There are ', int2str(sum(clusterQuality==2)), ' single unit clusters, ', int2str(sum(clusterQuality==1)), ' MUA clusters and ', int2str(sum(clusterQuality==0)), ' Noise clusters.']);

end
