clear all; clc;
figure_position = [(get(0,"screensize")(3) * 13 / 136) (get(0,"screensize")(4) * 1 / 4)...
                   (get(0,"screensize")(3) * 55 / 68 ) (get(0,"screensize")(4) * 1 / 2)];


# Part 1: Transmitter:

## 1. Uni-polar non-return to zero
tx1 = transmitter();
tx1 = tx1.create_stream(10000);
tx1 = tx1.line_code('unrz', 1.2);

figure('Name', 'Uni-polar non-return to zero, transmitter pt.1', 'Position', figure_position);
subplot(2, 1, 1);
tx1.plot('stream');
subplot(2, 1, 2);
tx1.plot('line_coded_stream');

figure('Name', 'Uni-polar non-return to zero, transmitter pt2.', 'Position', figure_position);
subplot(1, 2, 1);
tx1.plot_eyediagram('line_coded_stream');
subplot(1, 2, 2);
tx1.plot_line_code_power_spectrum();


## 2. Uni-polar return to zero
tx2 = transmitter();
tx2 = tx2.create_stream(10000);
tx2 = tx2.line_code('urz', 1.2);

figure('Name', 'Uni-polar return to zero, transmitter pt.1', 'Position', figure_position);
subplot(2, 1, 1);
tx2.plot('stream');
subplot(2, 1, 2);
tx2.plot('line_coded_stream');

figure('Name', 'Uni-polar return to zero, transmitter pt2.', 'Position', figure_position);
subplot(1, 2, 1);
tx2.plot_eyediagram('line_coded_stream');
subplot(1, 2, 2);
tx2.plot_line_code_power_spectrum();


## 3. Polar non-return to zero
tx3 = transmitter();
tx3 = tx3.create_stream(10000);
tx3 = tx3.line_code('pnrz', 1.2);

figure('Name', 'Polar non-return to zero, transmitter pt.1', 'Position', figure_position);
subplot(2, 1, 1);
tx3.plot('stream');
subplot(2, 1, 2);
tx3.plot('line_coded_stream');

figure('Name', 'Polar non-return to zero, transmitter pt.2', 'Position', figure_position);
subplot(1, 2, 1);
tx3.plot_eyediagram('line_coded_stream');
subplot(1, 2, 2);
tx3.plot_line_code_power_spectrum();

## 4. Polar return to zero
tx4 = transmitter();
tx4 = tx4.create_stream(10000);
tx4 = tx4.line_code('prz', 1.2);

figure('Name', 'Polar return to zero, transmitter pt.1', 'Position', figure_position);
subplot(2, 1, 1);
tx4.plot('stream');
subplot(2, 1, 2);
tx4.plot('line_coded_stream');

figure('Name', 'Polar return to zero, transmitter pt.2', 'Position', figure_position);
subplot(1, 2, 1);
tx4.plot_eyediagram('line_coded_stream');
subplot(1, 2, 2);
tx4.plot_line_code_power_spectrum();


## 5. Bipolar non-return to zero
tx5 = transmitter();
tx5 = tx5.create_stream(10000);
tx5 = tx5.line_code('bpnrz', 1.2);

figure('Name', 'Bipolar non-return to zero, transmitter pt.1', 'Position', figure_position);
subplot(2, 1, 1);
tx5.plot('stream');
subplot(2, 1, 2);
tx5.plot('line_coded_stream');

figure('Name', 'Bipolar non-return to zero, transmitter pt.2', 'Position', figure_position);
subplot(1, 2, 1);
tx5.plot_eyediagram('line_coded_stream');
subplot(1, 2, 2);
tx5.plot_line_code_power_spectrum();


## 6. Bipolar return to zero
tx6 = transmitter();
tx6 = tx6.create_stream(10000);
tx6 = tx6.line_code('bprz', 1.2);

figure('Name', 'Bipolar return to zero, transmitter pt.1', 'Position', figure_position);
subplot(2, 1, 1);
tx6.plot('stream');
subplot(2, 1, 2);
tx6.plot('line_coded_stream');

figure('Name', 'Bipolar return to zero, transmitter pt.2', 'Position', figure_position);
subplot(1, 2, 1);
tx6.plot_eyediagram('line_coded_stream');
subplot(1, 2, 2);
tx6.plot_line_code_power_spectrum();


## 7. Manchester
tx7 = transmitter();
tx7 = tx7.create_stream(10000);
tx7 = tx7.line_code('manchester', 1.2);

figure('Name', 'Manchester, transmitter pt.1', 'Position', figure_position);
subplot(2, 1, 1);
tx7.plot('stream');
subplot(2, 1, 2);
tx7.plot('line_coded_stream');

figure('Name', 'Manchester, transmitter pt.2', 'Position', figure_position);
subplot(1, 2, 1);
tx7.plot_eyediagram('line_coded_stream');
subplot(1, 2, 2);
tx7.plot_line_code_power_spectrum();


################################################################################

# Part 1: Reciever:

# 1. Uni-polar:
rx1 = receiver(tx1);
rx1 = rx1.extract_stream_from_line_code();

figure('Name', 'Uni-polar non-return to zero, receiver', 'Position', figure_position);
subplot(2, 1, 1);
rx1.plot('rx_line_coded_stream');
subplot(2, 1, 2);
rx1.plot('extracted_stream');

rx2 = receiver(tx2);
rx2 = rx2.extract_stream_from_line_code();

figure('Name', 'Uni-polar return to zero, receiver', 'Position', figure_position);
subplot(2, 1, 1);
rx2.plot('rx_line_coded_stream');
subplot(2, 1, 2);
rx2.plot('extracted_stream');

figure('Name', 'Uni-polar BER plots', 'Position', figure_position);
subplot(1, 2, 1);
[sigma_array, ber_array] = sweep_over_sigma(tx1, rx1, 40);
plot_ber(sigma_array, ber_array, tx1.line_coding_style);

subplot(1, 2, 2)
[sigma_array, ber_array] = sweep_over_sigma(tx2, rx2, 40);
plot_ber(sigma_array, ber_array, tx2.line_coding_style);


# 2. Polar:
rx3 = receiver(tx3);
rx3 = rx3.extract_stream_from_line_code();

figure('Name', 'Polar non-return to zero, receiver', 'Position', figure_position);
subplot(2, 1, 1);
rx3.plot('rx_line_coded_stream');
subplot(2, 1, 2);
rx3.plot('extracted_stream');

rx4 = receiver(tx4);
rx4 = rx4.extract_stream_from_line_code();

figure('Name', 'Polar return to zero, receiver', 'Position', figure_position);
subplot(2, 1, 1);
rx4.plot('rx_line_coded_stream');
subplot(2, 1, 2);
rx4.plot('extracted_stream');

figure('Name', 'Polar BER plots', 'Position', figure_position);
subplot(1, 2, 1);
[sigma_array, ber_array] = sweep_over_sigma(tx3, rx3, 40);
plot_ber(sigma_array, ber_array, tx3.line_coding_style);

subplot(1, 2, 2)
[sigma_array, ber_array] = sweep_over_sigma(tx4, rx4, 40);
plot_ber(sigma_array, ber_array, tx4.line_coding_style);


# 3. Bipolar:
rx5 = receiver(tx5);
rx5 = rx5.extract_stream_from_line_code();

figure('Name', 'Bipolar non-return to zero, receiver', 'Position', figure_position);
subplot(2, 1, 1);
rx5.plot('rx_line_coded_stream');
subplot(2, 1, 2);
rx5.plot('extracted_stream');

rx6 = receiver(tx6);
rx6 = rx6.extract_stream_from_line_code();

figure('Name', 'Bipolar return to zero, receiver', 'Position', figure_position);
subplot(2, 1, 1);
rx6.plot('rx_line_coded_stream');
subplot(2, 1, 2);
rx6.plot('extracted_stream');

figure('Name', 'Bipolar BER plots', 'Position', figure_position);
subplot(1, 2, 1);
[sigma_array, ber_array, detected_ber_array] = sweep_over_sigma(tx5, rx5, 40);
plot_ber(sigma_array, ber_array, tx5.line_coding_style, detected_ber_array);

subplot(1, 2, 2)
[sigma_array, ber_array, detected_ber_array] = sweep_over_sigma(tx6, rx6, 40);
plot_ber(sigma_array, ber_array, tx6.line_coding_style, detected_ber_array);

# 4. Manchester:
rx7 = receiver(tx7);
rx7 = rx7.extract_stream_from_line_code();

figure('Name', 'Manchester, receiver', 'Position', figure_position);
subplot(2, 1, 1);
rx5.plot('rx_line_coded_stream');
subplot(2, 1, 2);
rx5.plot('extracted_stream');

figure('Name', 'Manchester BER plot');
[sigma_array, ber_array] = sweep_over_sigma(tx7, rx7, 40);
plot_ber(sigma_array, ber_array, tx7.line_coding_style);


################################################################################

# Part 2: Transmitter:

tx_bpsk = transmitter();
tx_bpsk = tx_bpsk.create_stream(100);
tx_bpsk = tx_bpsk.line_code('pnrz', 1);
tx_bpsk = tx_bpsk.bpsk();

figure('Name', 'BPSK, transmitter pt.1', 'Position', figure_position);
subplot(3, 1, 1);
tx_bpsk.plot('stream');
subplot(3, 1, 2);
tx_bpsk.plot('line_coded_stream');
subplot(3, 1, 3);
tx_bpsk.plot('bpsk_modulated');

figure('Name', 'BPSK, transmitter pt.2', 'Position', figure_position);
subplot(1, 2, 1);
tx_bpsk.plot_line_code_power_spectrum();
subplot(1, 2, 2);
tx_bpsk.plot_bpsk_power_spectrum();

################################################################################

# Part 2: Receiver:

rx_bpsk = receiver(tx_bpsk);
rx_bpsk = rx_bpsk.extract_line_code_from_bpsk_modulated();
rx_bpsk = rx_bpsk.extract_stream_from_line_code();

figure('Name', 'BPSK, receiver', 'Position', figure_position);
subplot(3, 1, 1);
rx_bpsk.plot('rx_line_coded_stream');
subplot(3, 1, 2);
plot(rx_bpsk, 'noisy_rx_stream');
subplot(3, 1, 3);
rx_bpsk.plot('extracted_stream');

BER = rx_bpsk.get_bit_error_rate(tx_bpsk);
BER


################################################################################

# Adding noise without sweeping example:

rx_noise = receiver(tx1);
rx_noise = rx_noise.add_noise(0.5);
rx_noise = rx_noise.extract_stream_from_line_code();

figure('Name', 'Testing noisy RX', 'Position', figure_position);
subplot(3, 1, 1);
rx_noise.plot('rx_line_coded_stream');
subplot(3, 1, 2);
rx_noise.plot('noisy_rx_stream');
subplot(3, 1, 3);
rx_noise.plot('extracted_stream');

BER_test = rx_noise.get_bit_error_rate(tx1);
BER_test
