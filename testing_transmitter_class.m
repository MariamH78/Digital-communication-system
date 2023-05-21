clc
clear all

graphics_toolkit('fltk')

tee = transmitter();
tee = create_stream(tee, 10);
tee = tee.line_code("pnrz", 1);
tee = tee.bpsk();

subplot (2, 1, 1)
stairs(linspace(0, tee.time_limit, length(tee.line_coded_stream)), tee.line_coded_stream)
subplot (2, 1, 2)
plot(linspace(0, tee.time_limit, length(tee.bpsk_modulated)), tee.bpsk_modulated)


