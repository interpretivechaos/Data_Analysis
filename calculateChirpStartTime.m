function chirpStartTime=calculateChirpStartTime(unfilteredPhotodiodeTrace, samplerate)
switch nargin 
    case 1
    samplerate=30000;
end
filteredPhotodiodeTrace = sgolayfilt(double(unfilteredPhotodiodeTrace),1,91);
maxValue=max(filteredPhotodiodeTrace);
minValue=min(filteredPhotodiodeTrace);
threshold=(minValue+maxValue)/2

fluke=0;
flukeThreshold=100;
chirpStartTime=-1;

for i=1:length(filteredPhotodiodeTrace)
    
   if filteredPhotodiodeTrace(i)>threshold
       
       if fluke==0
           chirpStartTime=(i/samplerate-5);
       
       elseif fluke>flukeThreshold
           break
       
       end
       
       fluke=fluke+1;
       
   else
       fluke=0;
       chirpStartTime=-1;
   end
   
end

if chirpStartTime == -1
    disp('Could not find chirp')
end
   
end