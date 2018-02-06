function [masterMatrix, analogChannels, clusterQuality]=getKwikSpikesAndAnalog(kwikPath, pathTohdf5Dataset, kwdFile)

%GETKWIKSPIKESANDANALOG Takes a .kwik file and returns an m x n sparse matrix where
% m is the number of samples and n is the number of clusters

[rootKwikPath, kwikFileName, extension]=fileparts(kwikPath);

if nargin==1
        pathTohdf5Dataset='/recordings/0';
end

if nargin<3

        kwdFileList=dir(strcat(rootKwikPath, filesep, '**.kwd'));

        if max(size(kwdFileList))~=1
            disp('Too many .kwd files in same folder as .kwik, ignoring .kwd');
            disp('Try running with the name as second argument.');
        else
            kwdFile=kwdFileList(1).name();
        end
else
        disp(strcat('Using', kwdFile));

end

% Load .kwd
kwdPath=strcat(rootKwikPath, filesep, kwdFile);

%Read Data from computer
disp(kwdFile);
outputMatrix=h5read(kwdPath, strcat(pathTohdf5Dataset,'/data'));

%Calculate VoltageGain, strip away aux channels, and calculate the number fo channels.
VoltageGain=h5readatt(kwdPath, strcat(pathTohdf5Dataset,'/application_data'), 'channel_bit_volts');
VoltageGainMaster=VoltageGain(1);
disp(horzcat('Voltage Gain: ', num2str(VoltageGainMaster)));

% samplerate=h5readatt(kwdPath, strcat(pathTohdf5Dataset,'/application_data'), 'sample_rate');

OriginalChannelNumber=length(VoltageGain);
VoltageGain(VoltageGain~=VoltageGainMaster)=[]; %Strips accelerometer data.
NumChannels=length(VoltageGain);

analogChannels=outputMatrix(NumChannels-1:end, :)';

%Get Spikedata
[spiketimes, clusters, clusterQuality]=importKwikSpikes(kwikPath);

%Number of Clusters
numberOfClusters=double(max(clusters)+1);

%Need to calculate this properly, probably when grabbing analog data
%For now, just use last spike
% numberOfSamples=double(max(spiketimes)+1);
% Using size of analog channels

numberOfSamples=length(analogChannels);

%Create a matrix with a different row for each matrix. Saves space using
%sparse matrix

masterMatrix=sparse(numberOfSamples, numberOfClusters);

for i=1:length(spiketimes)
    masterMatrix(spiketimes(i), clusters(i)+1)=1;
end

end
