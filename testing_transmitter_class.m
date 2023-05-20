clc
clear all

graphics_toolkit('fltk')

tee = transmitter();
tee = create_stream(tee, 10);
%stairs(tee.stream)
tee = tee.line_code("urz", 1.2);

subplot (3, 1, 1)
stairs(1 : 1 : 20, tee.stream)
subplot (3, 1, 2)
stairs(1: 1 : 20, line_code(tee, "bpnrz", 1.2).line_coded_stream)
subplot (3, 1, 3)
stairs(1 : 1 : 20, line_code(tee, "bprz", 1.2).line_coded_stream)

