function filteredTrace=bandpassTrace(trace, lowFreq, hiFreq, samplerate)

[b, a] = butter(9, [lowFreq hiFreq]/(samplerate/2), 'bandpass');

filteredTrace = filter(b,a,trace);
%figure()

%dt = 1/samplerate;
% h=fvtool(b,a)


end

% [b,a] = butter(order, [lowFreq hiFreq]/(fs/2), 'bandpass');
%  y = filter(b,a,x)