clc
clear all

graphics_toolkit('fltk')

tee = transmitter();
tee = create_stream(tee, 50);
tee = tee.line_code("pnrz", 1);
tee = tee.bpsk();

tee

subplot (2, 1, 1)
stairs(tee.line_coded_stream)
subplot (2, 1, 2)
plot(tee.bpsk_modulated)


