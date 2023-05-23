function plot_ber(sigma_array, ber_array, line_coding_style, detected_ber_array)
  hold on;

  semilogy(sigma_array, ber_array, 'LineWidth', 1.5, 'Color', "#D10000");
  txt = {strjoin({'Maximum BER is' num2str(max(ber_array))}, ' ') '\downarrow'};
  text(sigma_array(length(sigma_array)), ber_array(length(ber_array)), txt, 'FontSize', 14,
       'HorizontalAlignment','right', 'VerticalAlignment','bottom');

  if nargin >= 4 && ~isnull(detected_ber_array)
    semilogy(sigma_array, detected_ber_array, 'LineWidth', 1.5, 'Color', "#00D100");
    txt = {'\uparrow' strjoin({'Maximum detected BER is' num2str(max(detected_ber_array))}, ' ')};
    text(sigma_array(length(sigma_array)), detected_ber_array(length(detected_ber_array)), txt, 'FontSize', 14,
       'HorizontalAlignment','right', 'VerticalAlignment','top');
    legend('BER', 'Detected BER', 'Location', 'southeast', 'FontSize', 14);
  endif

  title(['Sigma vs BER for ' line_coding_style ' line-coded stream'], 'FontSize', 20);
  xlabel('Sigma', 'FontSize', 18);
  ylabel('BER', 'FontSize', 18);
  axis([min(sigma_array) (1.1 * max(sigma_array))]);

  hold off;
endfunction

