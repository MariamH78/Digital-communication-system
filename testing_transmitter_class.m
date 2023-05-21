clc
clear all

graphics_toolkit('fltk')

tee = transmitter();
tee = create_stream(tee, 100);
tee = tee.line_code("pnrz", 1);
tee = tee.bpsk();


subplot (2, 1, 1)
plot_line_code_power_spectrum(tee.line_code("urz", 1.2));

subplot (2, 1, 2)
tee.plot_bpsk_power_spectrum()

