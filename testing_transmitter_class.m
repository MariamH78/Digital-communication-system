clc
clear all

graphics_toolkit('qt')

tee = transmitter();
tee = create_stream(tee, 10);
tee = tee.line_code("pnrz", 1.2);
tee = tee.bpsk();


subplot(3, 1, 1)
tee.plot('stream');
subplot(3, 1, 2);
tee.plot('line_coded_stream')
subplot(3, 1, 3);
tee.plot('bpsk_modulated')

figure;
tee.plot_eyediagram('stream');


