clc
clear all

graphics_toolkit('fltk');

function [sigma_array, ber_array, detected_ber_array] = sweep_over_sigma(tx_object, rx_object, number_of_sigma_values, sigma_limit)
  if nargin < 2 || ~isa(tx_object, 'transmitter') || ~isa(rx_object, 'receiver')
    error("Both a transmitter object and a receiver object must be passed to this function, in that order.");
  endif
  if nargin < 3
    number_of_sigma_values = 100;
  endif
  if nargin < 4
    sigma_limit = tx_object.vcc_positive;
  endif

  sigma_array = linspace(0, sigma_limit, number_of_sigma_values);
  ber_array = zeros(1, number_of_sigma_values);
  detected_ber_array = zeros(1, number_of_sigma_values);

  for i = 1 : number_of_sigma_values
    rx_object = add_noise(rx_object, sigma_array(i));
    rx_object = rx_object.extract_stream_from_line_code();
    ber_array(i) = get_bit_error_rate(rx_object, tx_object);
    detected_ber_array(i) = rx_object.detected_errors / rx_object.stream_size;
  endfor
endfunction

function plot_ber(sigma_array, ber_array, line_coding_style, detected_ber_array)
  figure;
  hold on;
  semilogy(sigma_array, ber_array, 'LineWidth', 1.5, 'Color', "#D10000");
  semilogy(sigma_array, detected_ber_array, 'LineWidth', 1.5, 'Color', "#00D100");
  hold off;
  title(['Sigma vs BER for ' line_coding_style ' line-coded stream'], 'FontSize', 20);
  xlabel('Sigma', 'FontSize', 18);
  ylabel('BER', 'FontSize', 18);

  txt = {strjoin({'Maximum BER is' num2str(max(ber_array))}, ' ') '\downarrow'};
  text(sigma_array(length(sigma_array)), ber_array(length(ber_array)), txt, 'FontSize', 14,
       'HorizontalAlignment','right', 'VerticalAlignment','bottom');

  txt = {'\uparrow' strjoin({'Maximum detected BER is' num2str(max(detected_ber_array))}, ' ')};
  text(sigma_array(length(sigma_array)), detected_ber_array(length(detected_ber_array)), txt, 'FontSize', 14,
       'HorizontalAlignment','right', 'VerticalAlignment','top');

  legend('BER', 'Detected BER', 'Location', 'southeast', 'FontSize', 14);
  axis([min(sigma_array) (1.1 * max(sigma_array))]);
  endfunction

tx = transmitter();
tx = tx.create_stream(1000);
tx = tx.line_code("bprz", 1);
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
