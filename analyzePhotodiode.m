%%T
subplot(2,1,1)
plot((unfilteredTraces(37, :)))
subplot(2,1,2)
plot(bandpassTrace(double(unfilteredTraces(37, :)), 1000, 7000, 30000));
% axis([0,   7000, -10^7, 10^7])

%%

figure(1)
smtlb = sgolayfilt(double(unfilteredTraces(37, :)),1,91);
sr=30000; %Sample rate
t=1:length(smtlb);
t=t./sr;
%%

startTime=0;
endTime=160;

% Start Threshold
% startTime=45.8295;
% endTime=45.83;

% % End Time
% startTime=79.823;
% endTime=79.831;

disp(1/(endTime-startTime))

subplot(4,1,1)
plot(t, (unfilteredTraces(37, :)))
axis([startTime, endTime, 1.5*10^4, 1.7*10^4])
subplot(4,1,2)

plot(t, smtlb);
axis([startTime, endTime, 1.56*10^4, 1.63*10^4])

subplot(4,1,3)
extendedChirp=zeros(size(t));
chirp=createChirpStimulus();


stimulusLength=length(chirp)-1;
% offset=floor(40.8298*sr);

offset=calculateChirpStartTime(unfilteredTraces(37, :))*sr;

size(chirp)
size(extendedChirp(offset:(offset+stimulusLength)))
extendedChirp(offset:offset+stimulusLength)=extendedChirp(offset:(offset+stimulusLength))+chirp';
plot(t, extendedChirp);
axis([startTime, endTime, 0, 1]);

subplot(4,1,4)
disp(length(t))
disp(length(chirp))
plot(t(1:length(chirp)), chirp)