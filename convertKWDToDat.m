%% convertKWDToDat(hdf5File, pathToDataset, fileOutName) converts .kwd to .dat for use with phy binary.
%
% Expects a .kwd file (hdf5), the path to the recording (e.g. /recordings/0/), and an output name.
% It also strips any files with a different VoltageGain than the first channel 
% (e.g. the aux channels of an Intan Headstage (phy presumes identical gain)). 
% This will cause a bug if they are not the last channels in the file.
% Generates a .dat file and a .prm file with the sample_rate, voltage_gain, and number of channels from the .kwd file.
% The .prm file is the the sample file 

function [kwikFilePath, pathTohdf5Dataset]=convertKWDToDat(hdf5File, pathTohdf5Dataset, fileOutName)

if nargin<2
        pathTohdf5Dataset='/recordings/0';
end
if nargin<3
       fileOutName='_recordings_0'
end

%Read Data from computer
[hdf5FilePath, hdf5FileName] = fileparts(hdf5File);
hdf5FileName=stripExtensions(hdf5FileName);
outputmatrix=h5read(hdf5File, strcat(pathTohdf5Dataset,'/data'));

%Find SampleRate
sampleRate=h5readatt(hdf5File, pathTohdf5Dataset, 'sample_rate');
disp(horzcat('Sample Rate: ', num2str(sampleRate), ' Hz'));


%Calculate VoltageGain, strip away aux channels, and calculate the number fo channels.
VoltageGain=h5readatt(hdf5File, strcat(pathTohdf5Dataset,'/application_data'), 'channel_bit_volts');
VoltageGainMaster=VoltageGain(1);
disp(horzcat('Voltage Gain: ', num2str(VoltageGainMaster)));

OriginalChannelNumber=length(VoltageGain);
VoltageGain(VoltageGain~=VoltageGainMaster)=[]; %Strips accelerometer data.
NumChannels=length(VoltageGain);

disp(strcat('Number of Channels:', num2str(NumChannels)));

if OriginalChannelNumber~=NumChannels
	disp(horzcat(num2str(OriginalChannelNumber-NumChannels), ' channels with different voltage gain removed (probably aux channels).'));
	disp('If these were not at the end of the file, you will get an error.');
end

fileOutPath=strcat(hdf5FilePath, filesep, hdf5FileName, fileOutName);
% Write binary .dat file.
fileOut = fopen(horzcat(fileOutPath, '.dat'), 'w');

fwrite(fileOut, outputmatrix(1:NumChannels, :),'int16');
fclose(fileOut);
disp(horzcat('Wrote ', fileOutPath, '.dat'));

%Create .prm file for phy, using information from .kwd
prmFile = fopen(strcat(fileOutPath, '.prm'), 'w');

experimentName=strcat(hdf5FileName, fileOutName);
fprintf(prmFile, 'experiment_name = ''%s''\n', experimentName);

%The .prb file should be either in the file with the data, or wherever phy
%keeps everything
fprintf(prmFile, 'prb_file = ''1x32_buzsaki''\n\n');
fprintf(prmFile, 'traces = dict(\n    raw_data_files=[experiment_name + ''.dat''],\n');
fprintf(prmFile, '    voltage_gain=%g,\n', VoltageGain(1));
fprintf(prmFile, '    sample_rate=%d,\n', sampleRate);
fprintf(prmFile, '    n_channels=%d,\n', NumChannels);

%Ugly lines with everything else not extracted from .kwd 
%Change any features you need here (or in the .prm after the fact)

fprintf(prmFile, '    dtype=''int16'',\n)\n\nspikedetekt = dict(\n');
fprintf(prmFile, '    filter_low=500.,  # Low pass frequency (Hz)\n');
fprintf(prmFile, '    filter_high_factor=0.95 * .5,\n');
fprintf(prmFile, '    filter_butter_order=3,  # Order of Butterworth filter.\n\n');
fprintf(prmFile, '    filter_lfp_low=0,  # LFP filter low-pass frequency\n');
fprintf(prmFile, '    filter_lfp_high=300,  # LFP filter high-pass frequency\n\n');
fprintf(prmFile, '    chunk_size_seconds=1,\n');
fprintf(prmFile, '    chunk_overlap_seconds=.015,\n\n');
fprintf(prmFile, '    n_excerpts=50,\n');
fprintf(prmFile, '    excerpt_size_seconds=1,\n');
fprintf(prmFile, '    threshold_strong_std_factor=4.5,\n');
fprintf(prmFile, '    threshold_weak_std_factor=2.,\n');
fprintf(prmFile, '    detect_spikes=''negative'',\n\n');
fprintf(prmFile, '    connected_component_join_size=1,\n\n');
fprintf(prmFile, '    extract_s_before=16,\n    extract_s_after=16,\n\n');
fprintf(prmFile, '    n_features_per_channel=3,  # Number of features per channel.\n');
fprintf(prmFile, '    pca_n_waveforms_max=10000,\n)\n\n');
fprintf(prmFile, 'klustakwik2 = dict(\n');
fprintf(prmFile, '    num_starting_clusters=100,\n)\n');


fclose(prmFile);
kwikFilePath=horzcat(fileOutPath, '.kwik');
disp(horzcat('Wrote ', fileOutPath, '.prm'));
% disp('phy spikesort paramsnew.prm --overwrite')
disp('You will want to run source activate klusta')
disp(strcat('klusta', experimentName, '.prm --overwrite'));
system(strcat('open -a Terminal "', hdf5FilePath, '"'));
end
