%makefigurefrom .kwd.raw

function [x, t]=importRawTrace(Path, record, channel, startMinute, endMinute)
RecordingPath='/recordings/';
RecordingPath=strcat(RecordingPath, num2str(record), '/data');
disp(RecordingPath);
traces=h5read(Path, RecordingPath);
sizeTraces=size(traces);

if 0<channel && channel<=sizeTraces(1)
    x=traces(channel, :);
    disp('Hi');
else
    disp('Using all channels');
end

startSample=floor(startMinute*60*30000)+1
endSample=floor(endMinute*60*30000)

x=x(:, startSample:endSample);

t=0:length(x)-1;
% t=t./30000;
t=t./(30000*60);

end