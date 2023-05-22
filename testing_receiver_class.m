clc
clear all

graphics_toolkit('fltk');

function [sigma_array, ber_array] = sweep_over_sigma(tx_object, rx_object, number_of_sigma_values, sigma_limit)
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
  for i = 1 : number_of_sigma_values
    rx_object = add_noise(rx_object, sigma_array(i));
    rx_object = rx_object.extract_stream_from_line_code();
    ber_array(i) = get_bit_error_rate(rx_object, tx_object);
  endfor
endfunction

function plot_ber(sigma_array, ber_array, line_coding_style)
  figure;
  semilogy(sigma_array, ber_array, 'LineWidth', 1.5, 'Color', "#D10000");
  title(['Sigma vs BER for ' line_coding_style ' line-coded stream'], 'FontSize', 20);
  xlabel('Sigma', 'FontSize', 18);
  ylabel('BER', 'FontSize', 18);
  txt = {strjoin({'Maximum BER is' num2str(max(ber_array))}, ' ') '\downarrow'};
  text(sigma_array(length(sigma_array)), ber_array(length(ber_array)), txt, 'FontSize', 14,
       'HorizontalAlignment','right', 'VerticalAlignment','bottom');
endfunction

tx = transmitter();
tx = tx.create_stream(10000);
tx = tx.line_code("urz", 1.2);
%tx = tx.bpsk();
rx = receiver(tx);


[sigma_array, ber_array] = sweep_over_sigma(tx, rx, 10);
plot_ber(sigma_array, ber_array, tx.line_coding_style);
