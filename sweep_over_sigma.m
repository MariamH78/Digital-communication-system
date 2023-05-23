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
