function binnedMatrix=binSpikes(spikeMatrix, binSize)
%BINSPIKES takes a matrix of spikes, and bins them into bins of size
sizeSpikeMatrix=size(spikeMatrix);
numberOfSamples=sizeSpikeMatrix(1);
% %Bin the samples
% binSize=1000
binNumber=double(ceil(numberOfSamples/binSize));
binnedMatrix=zeros(binNumber, sizeSpikeMatrix(2));

i=1;
for i=1:numberOfSamples
  index=ceil(double(i)/binSize);
  binnedMatrix(index, :)=binnedMatrix(index, :)+spikeMatrix(i, :);
end

% max(binnedMatrix)
% figure()
% 
% disp(kwikPath)
% 
% 
% fullrawdatapath=strcat(kwikroot, h5readatt(kwikPath, '/recordings/0/raw','dat_path'))
% % 
% 
% disp(numberOfSamples)
% x=1:19; % 0 to 10 s, 1000 samples
% y=linspace(0, numberOfSamples/samplerate, binNumber); % 10^1 to 10^3, 1000 samples
% imagesc(y,x,binnedMatrix');
% % set(gca,'Yscale','normal','Ydir','normal');

% imagesc(binnedMatrix');

end