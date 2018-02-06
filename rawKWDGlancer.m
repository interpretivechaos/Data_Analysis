% rawKWdGlancer
% Load .hdf5 File
function outside=rawKWDGlancer(filename)


h5disp(filename)
outside=hdf5read(filename, '/recordings/0/data');
matrixsize=size(outside)
	figure(1)
for i=1:32

	subplot(32, 1, i)
	plot(outside(i,:))
%    subplot(1, 2, 2)
%    plot(outside(33,:))
end
figure(2)
for i=1:11
    
    subplot(11,1,i)
    plot(outside(32+i,:))
    
end

figure(3)
    plot(outside(37,:))


end