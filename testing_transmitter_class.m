clc
clear all

graphics_toolkit('fltk')

tee = transmitter();
tee = create_stream(tee, 100);
tee = tee.line_code("bpnrz", 1.2);
%tee = tee.bpsk();


tee.plot_eyediagram('stream')
tee.plot_eyediagram('line_coded_stream')



