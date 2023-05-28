clear all; clc;
figure_position = [(get(0,"screensize")(3) * 13 / 136) (get(0,"screensize")(4) * 1 / 4)...
                   (get(0,"screensize")(3) * 55 / 68 ) (get(0,"screensize")(4) * 1 / 2)];


# Part 1: Transmitter:

## 1. Uni-polar non-return to zero
tx1 = transmitter();
tx1 = tx1.create_stream(10000);
tx1 = tx1.line_code('unrz', 1.2);

## 2. Uni-polar return to zero
tx2 = transmitter();
tx2 = tx2.create_stream(10000);
tx2 = tx2.line_code('urz', 1.2);

## 3. Polar non-return to zero
tx3 = transmitter();
tx3 = tx3.create_stream(10000);
tx3 = tx3.line_code('pnrz', 1.2);

## 4. Polar return to zero
tx4 = transmitter();
tx4 = tx4.create_stream(10000);
tx4 = tx4.line_code('prz', 1.2);

## 5. Bipolar non-return to zero
tx5 = transmitter();
tx5 = tx5.create_stream(10000);
tx5 = tx5.line_code('bpnrz', 1.2);

## 6. Bipolar return to zero
tx6 = transmitter();
tx6 = tx6.create_stream(10000);
tx6 = tx6.line_code('bprz', 1.2);

## 7. Manchester
tx7 = transmitter();
tx7 = tx7.create_stream(10000);
tx7 = tx7.line_code('manchester', 1.2);

################################################################################

# Recievers:

# 1. Uni-polar:
rx1 = receiver(tx1);
rx1 = rx1.extract_stream_from_line_code();

rx2 = receiver(tx2);
rx2 = rx2.extract_stream_from_line_code();

# 2. Polar:
rx3 = receiver(tx3);
rx3 = rx3.extract_stream_from_line_code();

rx4 = receiver(tx4);
rx4 = rx4.extract_stream_from_line_code();

# 3. Bipolar:
rx5 = receiver(tx5);
rx5 = rx5.extract_stream_from_line_code();

rx6 = receiver(tx6);
rx6 = rx6.extract_stream_from_line_code();

# 4. Manchester:
rx7 = receiver(tx7);
rx7 = rx7.extract_stream_from_line_code();


#All BER plots
figure;
hold on;

[sigma_array, ber_array] = sweep_over_sigma(tx1, rx1, 40);
semilogy(sigma_array, ber_array, 'LineWidth', 1.5);

[sigma_array, ber_array] = sweep_over_sigma(tx2, rx2, 40);
semilogy(sigma_array, ber_array, 'LineWidth', 1.5);

[sigma_array, ber_array] = sweep_over_sigma(tx3, rx3, 40);
semilogy(sigma_array, ber_array, 'LineWidth', 1.5);

[sigma_array, ber_array] = sweep_over_sigma(tx4, rx4, 40);
semilogy(sigma_array, ber_array, 'LineWidth', 1.5);

[sigma_array, ber_array] = sweep_over_sigma(tx5, rx5, 40);
semilogy(sigma_array, ber_array, 'LineWidth', 1.5);

[sigma_array, ber_array, detected_ber_array] = sweep_over_sigma(tx6, rx6, 40);
semilogy(sigma_array, ber_array, 'LineWidth', 1.5);

[sigma_array, ber_array] = sweep_over_sigma(tx7, rx7, 40);
semilogy(sigma_array, ber_array, 'LineWidth', 1.5);

legend('UNRZ', 'URZ', 'PNRZ', 'PRZ', 'BPNRZ', 'BPRZ', 'MNCHSTR',...
       'Location', 'southeast', 'FontSize', 14);
title(['Sigma vs BER for all line-coding styles'], 'FontSize', 20);
xlabel('Sigma', 'FontSize', 18);
ylabel('BER', 'FontSize', 18);

hold off;

