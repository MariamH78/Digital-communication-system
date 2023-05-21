clc
clear all

graphics_toolkit('fltk')

tee = transmitter();
tee = create_stream(tee, 15);
tee = tee.line_code("pnrz", 1);
tee = tee.bpsk();

%propertyName = 'stream';
%tee.(propertyName)

subplot (3, 1, 1)
tee.plot('stream')

subplot (3, 1, 2)
plot(tee, 'line_coded_stream')

subplot (3, 1, 3)
plot(tee, 'bpsk_modulated')

terqee = transmitter([1 0 1 0]);

figure;
plot(terqee, 'stream')
