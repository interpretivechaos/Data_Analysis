function plotSpikes(spikeMatrix, analogChannels, clusterQuality, startTime, endTime)

%figure out time matrix
SAMPLE_RATE=30000;
t=1:length(analogChannels);

startIndex=startTime*SAMPLE_RATE+1;
endIndex=endTime*SAMPLE_RATE;

if startIndex>=length(analogChannels)
    startIndex=1;
end

if endIndex>=length(analogChannels)
    endIndex=length(analogChannels);
end

figure(1)
clf
binSize=500;
binnedSpikes=binSpikes(spikeMatrix, binSize);
subplot(4,1,1)

binStartIndex=floor(startIndex/binSize)+1;
binEndIndex=floor(endIndex/binSize);

for i=1:length(spikeMatrix(1,:))
    
    %clusterQuality (0=noise, 1=MUA, 2=Single Unit)
    if clusterQuality(i)==1
        subplot(4,1,1)
        plot(binnedSpikes(binStartIndex:binEndIndex,i))

    elseif clusterQuality(i)==2
        subplot(4,1,2)
        plot(binnedSpikes(binStartIndex:binEndIndex,i));
        hold on
    end
    
end

subplot(4,1,1)
title('MUA Spikes')
hold off

subplot(4,1,2)
title('Single Units')
hold off

t=t./SAMPLE_RATE;

figure(1)
subplot(4,1,3)
plot(t(startIndex:endIndex), analogChannels(startIndex:endIndex,[2]));
title('Photodiode');

subplot(4,1,4)
plot(t(startIndex:endIndex), analogChannels(startIndex:endIndex,[6]));
xlabel('Time in Seconds');
title('Optogenetics');

hold off

end
