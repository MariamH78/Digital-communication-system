classdef receiver
  properties
    rx_line_coded_stream = []; %unmodified transmitter stream
    noisy_rx_stream = [];
    sigma = 0.0;
    stream_size = 0.0;
    time_limit = 0.0;

    line_coding_style = '';
    rx_bpsk_stream = [];

    vcc_positive = 0.0;
    vcc_negative = 0.0;
    extracted_stream = []; %0's and 1's

  endproperties
  methods
    function obj = receiver (transmitter_object)
      if nargin < 1
        error("A transmitter object must be created first and passed into this constructor.");
      endif
      if (isnull(transmitter_object.line_coded_stream))
        error("transmitter object's line_code function must be called before initializing the receiver's values.");
      endif

      obj.rx_line_coded_stream = transmitter_object.line_coded_stream;
      obj.rx_bpsk_stream = transmitter_object.bpsk_modulated;
      obj.noisy_rx_stream = obj.rx_line_coded_stream;
      obj.extracted_stream = []; %0's and 1's
      obj.stream_size = transmitter_object.stream_size;
      obj.line_coding_style = transmitter_object.line_coding_style;
      obj.vcc_positive = transmitter_object.vcc_positive;
      obj.vcc_negative = transmitter_object.vcc_negative;
      obj.time_limit = transmitter_object.time_limit;

    endfunction

    function obj = add_noise(obj, sigma)
      if ~isa(obj, 'receiver')
        error("Passed object is not of the receiver type.");
      endif
      if nargin < 2
        error("Sigma (standard deviation) for the added noise must be provided as an argument to the function.");
      endif

      noise = sigma * randn(1, length(obj.rx_line_coded_stream));
      obj.sigma = sigma;
      obj.noisy_rx_stream = obj.rx_line_coded_stream + noise;
    endfunction

    function obj = extract_stream_from_line_code (obj)

      obj.extracted_stream = zeros(1, obj.stream_size);

      if (strcmp(obj.line_coding_style,'unrz') == 1)
        decision_level = obj.vcc_positive / 2;
        for i = 2 : 2 : obj.stream_size * 2
            if (obj.noisy_rx_stream(i - 1) + obj.noisy_rx_stream(i)) / 2 > decision_level
              obj.extracted_stream(i / 2) = 1;
            endif
        endfor
      endif

      if (strcmp(obj.line_coding_style,'urz')==1)
          decision_level = obj.vcc_positive / 2;
          for i = 2 : 2 : obj.stream_size*2
            if obj.noisy_rx_stream(i - 1) > decision_level
              obj.extracted_stream(i / 2) = 1;
            endif
        endfor
      endif

      if (strcmp(obj.line_coding_style,'pnrz') == 1)
        decision_level = (obj.vcc_positive + obj.vcc_negative) / 2;
        for i = 2 : 2 : obj.stream_size*2
            if (obj.noisy_rx_stream(i - 1) + obj.noisy_rx_stream(i)) / 2 > decision_level
              obj.extracted_stream(i / 2) = 1;
            endif
        endfor
      endif

      if (strcmp(obj.line_coding_style,'prz')==1)
        decision_level = (obj.vcc_positive + obj.vcc_negative) / 2;
        for i = 2 : 2 : obj.stream_size * 2
            if obj.noisy_rx_stream(i - 1) > decision_level
             obj.extracted_stream(i / 2) = 1;
            endif
        endfor
      endif


      if (strcmp(obj.line_coding_style,'bpnrz')==1)
        decision_level_high = obj.vcc_positive / 2;
        decision_level_low  = obj.vcc_negative / 2;
        for i = 2 : 2 : obj.stream_size * 2
            if ((obj.noisy_rx_stream(i - 1) + obj.noisy_rx_stream(i)) / 2 > decision_level_high ||
               (obj.noisy_rx_stream(i - 1) + obj.noisy_rx_stream(i)) / 2 < decision_level_low)
              obj.extracted_stream(i / 2) = 1;
            endif
        endfor
      endif

      if (strcmp(obj.line_coding_style,'bprz')==1)
        decision_level_high = obj.vcc_positive / 2;
        decision_level_low  = obj.vcc_negative / 2;
        for i = 2 : 2 : obj.stream_size * 2
            if obj.noisy_rx_stream(i - 1) > decision_level_high || obj.noisy_rx_stream(i - 1) < decision_level_low
              obj.extracted_stream(i / 2) = 1;
            endif
        endfor
      endif

      if (strcmp(obj.line_coding_style,'manchester')==1)
        decision_level = (obj.vcc_positive + obj.vcc_negative) / 2;
        for i = 2 : 2 : obj.stream_size * 2
            if obj.noisy_rx_stream(i - 1) > decision_level && obj.noisy_rx_stream(i) < decision_level
              obj.extracted_stream(i / 2) = 1;
            endif
        endfor
      endif

      endfunction

      function ber = get_bit_error_rate(obj, transmitter_object)
        if nargin < 2
          error("The transmitter object whose stream will be compared must be passed as a second argument.");
        endif
        if ~isa(obj, 'receiver') || ~isa(transmitter_object, 'transmitter')
          error("The function must be used as follows -> receiver_object.get_bit_error_rate(transmitter_object).");
        endif
        if isnull(obj.extracted_stream)
          error("receiver_object.extract_stream_from_line_code() or extract_stream_from_bpsk_modulated must be called first!");
        endif
        if isnull(transmitter_object.stream)
          error("transmitter_object's stream must first be initialized at construction time or by calling create_stream().");
        endif

        ber = 0;
        for i = 2 : 2 : obj.stream_size * 2
          if obj.extracted_stream(i / 2) ~= transmitter_object.stream(i)
            ber += 1;
          endif
        endfor
        ber /= obj.stream_size;

      endfunction

      function plot (obj, param)
        if ~isa(obj, 'receiver')
          error("Passed object is not of the receiver type.");
        endif
        if nargin < 2
          error("You must include the parameter you want to plot.");
        endif

        if strcmp(param, 'noisy_rx_stream') == 1
          stream = [obj.noisy_rx_stream  obj.noisy_rx_stream(length(obj.noisy_rx_stream))];
          stairs(linspace(0, obj.time_limit, length(stream)), stream, 'LineWidth', 1.5, 'Color', "#003049");
          title(['Noisy received stream with sigma = ' obj.sigma], 'FontSize', 20);
          xlabel('Time (in S)', 'FontSize', 18);
          ylabel('Volt (in V)', 'FontSize', 18);

        elseif strcmp(param, 'rx_line_coded_stream') == 1
          line_coded_stream = [obj.rx_line_coded_stream  obj.rx_line_coded_stream(length(obj.rx_line_coded_stream))];
          stairs(linspace(0, obj.time_limit, length(line_coded_stream)), line_coded_stream, 'LineWidth',1.5, 'Color', "#d62828");
          title(['Unmodified received stream (encoded using '  obj.line_coding_style  ')'], 'FontSize', 20);
          xlabel('Time (in S)', 'FontSize', 18);
          ylabel('Volt (in V)', 'FontSize', 18);

        elseif strcmp(param, 'rx_bpsk_stream') == 1
          plot(linspace(0, obj.time_limit, length(obj.bpsk_modulated)), obj.bpsk_modulated, 'LineWidth',1.5, 'Color', "#f77f00");
          title('Unmodified BPSK modulated received stream', 'FontSize', 20);
          xlabel('Time (in S)', 'FontSize', 18);
          ylabel('Amplitude (in V)', 'FontSize', 18);

        elseif strcmp(param, 'extracted_stream')
          stream = [obj.noisy_rx_stream  obj.noisy_rx_stream(length(obj.noisy_rx_stream))];
          stairs(linspace(0, obj.time_limit, length(stream)), stream, 'LineWidth', 1.5, 'Color', "#003049");
          title('Extracted message stream', 'FontSize', 20);
          xlabel('Time (in S)', 'FontSize', 18);
          ylabel('Data', 'FontSize', 18);

        else
          error("The parameter passed to the function doesn't exist.");
        endif
      endfunction
  endmethods
endclassdef
