clc
clear all

graphics_toolkit('fltk');



tx = transmitter();
tx = tx.create_stream(1000);
tx = tx.line_code("bpnrz", 1);
#tx = tx.bpsk();

rx = receiver(tx);
%rx = rx.extract_line_code_from_bpsk_modulated();
%rx = rx.extract_stream_from_line_code();

%rx.rx_line_coded_stream
%rx.extracted_stream

%subplot(2, 1, 1)
%rx.plot('rx_line_coded_stream')
%subplot(2, 1, 2)
%plot(rx, 'noisy_rx_stream');
%subplot(3, 1, 3)
%rx.plot('extracted_stream');

[sigma_array, ber_array, detected_ber_array] = sweep_over_sigma(tx, rx, 100);
plot_ber(sigma_array, ber_array, tx.line_coding_style, detected_ber_array);
