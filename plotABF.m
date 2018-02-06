function [d, si, h]=plotABF(fileName)
%PLOTABF Plots the first trace from an abf file.
    [d, si, h]=abfload(fileName);
    t=1:length(d(:,1));
    %Convert time matrix to seconds (si is time between samples in µs)
    t=t.*si*10^-6;
    
    
    figure(1)
    clf
    plot(t,d(:, 1))
    xlabel('Time in seconds')
    ylabel('Voltage in mV')
   
end
