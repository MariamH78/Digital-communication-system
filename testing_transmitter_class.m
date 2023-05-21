clc
clear all

graphics_toolkit('fltk')

tee = transmitter();
tee = create_stream(tee, 10000);
%tee = tee.line_code("urz", 1.2);
%tee = tee.bpsk();

subplot (2, 1, 1)
plot_line_code_power_spectrum(tee.line_code("urz", 1.2));

subplot (2, 1, 2)
plot_line_code_power_spectrum(tee.line_code("unrz", 1.2))

