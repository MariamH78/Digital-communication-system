classdef transmitter
  properties
    stream = [];
    time_limit = 0.0;
    line_coded_stream = [];
    bpsk_modulated = [];
    line_coding_style = '';
    stream_size = 0;
    vcc_positive = 0.0; %VCC+ and VCC- are later used by the receiver class
    vcc_negative = 0.0;
  endproperties

  methods
    function obj = transmitter (input_stream, bitrate)
      obj.stream = [];
      time_domain_vector = [];
      obj.line_coded_stream = [];
      obj.bpsk_modulated = [];
      obj.line_coding_style = '';
      obj.stream_size = 0;
      if (nargin >= 1)
        if size(input_stream)(1) ~= 1 || size(input_stream(2)) == 0
          error("Array dimensions don't conform to transmitter class's specifications. Array must be 1xN, and N must be larger than 0.");
        endif

        for i = 1 : length(input_stream)
          if input_stream(i) ~= 0 && input_stream(i) ~= 1
            error(["Data entered must have only 0's and 1's. The entry number " string(i) " is neither."]);
          endif
        endfor

        obj.stream = repelem(input_stream, 2);
        obj.stream_size = length(input_stream);

        if (nargin < 2)
          bitrate = 100
        endif

        obj.time_limit = obj.stream_size * 1/bitrate - 1/bitrate;
      endif
    endfunction

    function obj = create_stream (obj, stream_size, bitrate)
      if ~isa(obj, 'transmitter')
        error("Passed object is not of the transmitter type.");
      endif
      if nargin < 3
          bitrate = 100;
      endif
      if nargin == 0 || nargin == 1 || (nargin >= 2 && stream_size == 0)
        stream_size = 10000;
      endif

      temp = randi([0 1], 1, stream_size);
      obj.stream = repelem(temp, 2);
      obj.stream_size = stream_size;
      obj.time_limit = obj.stream_size * 1/bitrate - 1/bitrate;
    endfunction

    function obj = line_code (obj, line_coding_style, vcc_positive, vcc_negative)
      if ~isa(obj, 'transmitter')
        error("Passed object is not of the transmitter type.");
      endif

      if obj.stream_size == 0
        error("You need to call create_stream first!");
      endif

      if nargin < 3
        error("Not enough arguments. Make sure to enter both line coding style and vcc.");
      endif

      if nargin < 4
        vcc_negative = vcc_positive * -1;
      endif

      obj.vcc_positive = vcc_positive;
      obj.vcc_negative = vcc_negative;
      obj.line_coding_style = line_coding_style;
      obj.line_coded_stream = zeros (1, obj.stream_size * 2);

      styles = {'unrz' 'urz' 'pnrz' 'prz' 'bpnrz' 'bprz' 'manchester'};

      index = find(strcmp(styles, line_coding_style));
      switch index
        case 1 %unipolar non-return to zero
          for i = 1 : obj.stream_size * 2
            if (obj.stream(i) == 1)
              obj.line_coded_stream(i) = vcc_positive;
            endif
          endfor
        case 2  %unipolar return to zero
          for i = 1 : obj.stream_size * 2
            if (obj.stream(i) == 1 && (mod(i, 2) == 1))
              obj.line_coded_stream(i) = vcc_positive;
            endif
          endfor

        case 3 %polar non-return to zero
          for i = 1 : obj.stream_size * 2
            if (obj.stream(i) == 1)
              obj.line_coded_stream(i) = vcc_positive;
            else
              obj.line_coded_stream(i) = vcc_negative;
            endif
          endfor

        case 4 %polar return to zero
          for i = 1 : obj.stream_size * 2
            if (obj.stream(i) == 1 && (mod(i, 2) == 1))
              obj.line_coded_stream(i) = vcc_positive;
            elseif mod(i, 2) == 1
              obj.line_coded_stream(i) = vcc_negative;
            endif
          endfor

        case 5 %bipolar non-return to zero
          flag = 1;
          for i = 1 : obj.stream_size * 2
            if (obj.stream(i) == 1 && flag)
              obj.line_coded_stream(i) = vcc_positive;
              if (mod(i, 2) == 0)
                flag = 0;
              endif
            elseif (obj.stream(i) == 1 && ~flag)
              obj.line_coded_stream(i) = vcc_negative;
              if (mod(i, 2) == 0)
                flag = 1;
              endif
            endif
          endfor

        case 6 %bipolar return to zero
          flag = 1;
          for i = 1 : obj.stream_size * 2
            if (obj.stream(i) == 1 && flag && (mod(i, 2) == 1))
              obj.line_coded_stream(i) = vcc_positive;
              flag = 0;
            elseif (obj.stream(i) == 1 && ~flag && (mod(i, 2) == 1))
              obj.line_coded_stream(i) = vcc_negative;
              flag = 1;
            endif
          endfor

        case 7 %manchester
          for i = 1 : obj.stream_size * 2
            if (obj.stream(i) == 1)
              if (mod(i, 2) == 1)
                obj.line_coded_stream(i) = vcc_positive;
              else
                obj.line_coded_stream(i) = vcc_negative;
              endif
            else
              if (mod(i, 2) == 1)
                obj.line_coded_stream(i) = vcc_negative;
              else
                obj.line_coded_stream(i) = vcc_positive;
              endif
            endif
          endfor

        otherwise
          error(["The selected line coding style, '" line_coding_style "', is not supported. The currently supported styles are: " strjoin(styles, ', ') '.']);
      endswitch
    endfunction

    function obj = bpsk (obj)
      if ~isa(obj, 'transmitter')
        error("Passed object is not of the transmitter type.");
      endif
      if isnull(obj.line_coded_stream) || strcmp(obj.line_coding_style, 'pnrz') ~= 1
        error("transmitter_object.line_code('pnrz', vcc) must be called first.");
      endif

      obj.bpsk_modulated = zeros(1, obj.stream_size * 2/0.01);
      temp = repelem(obj.line_coded_stream, 50);
      for i = 1 : length(temp)
        obj.bpsk_modulated (i) = cos(2 * 3.14159265  * 10000000 * i) * temp(i);
      endfor
    endfunction

    function plot(obj, param)
      if ~isa(obj, 'transmitter')
        error("Passed object is not of the transmitter type.");
      endif
      if nargin < 2
        error("You must include the parameter you want to plot.");
      endif

      if strcmp(param, 'stream') == 1
        stream = [obj.stream  obj.stream(length(obj.stream))];
        stream = repelem(stream, 50);
        plot(linspace(0, obj.time_limit, length(stream)), stream, 'LineWidth', 1.5, 'Color', "#003049");
        title('Unmodified bits stream (0/1)', 'FontSize', 20);
        xlabel('Time (in S)', 'FontSize', 18);
        ylabel('Data (0/1)', 'FontSize', 18);
        xlim = [0 0.1];

      elseif strcmp(param, 'line_coded_stream') == 1
        line_coded_stream = [obj.line_coded_stream  obj.line_coded_stream(length(obj.line_coded_stream))];
        line_coded_stream = repelem(line_coded_stream, 50);
        plot(linspace(0, obj.time_limit, length(line_coded_stream)), line_coded_stream, 'LineWidth',1.5, 'Color', "#d62828");
        title(['Line coded bits stream (encoded using '  obj.line_coding_style  ')'], 'FontSize', 20);
        xlabel('Time (in S)', 'FontSize', 18);
        ylabel('Volt (in V)', 'FontSize', 18);
        xlim = [0 0.1];

      elseif strcmp(param, 'bpsk_modulated') == 1
        plot(linspace(0, obj.time_limit, length(obj.bpsk_modulated)), obj.bpsk_modulated, 'LineWidth',1.5, 'Color', "#f77f00");
        title('BPSK modulated stream', 'FontSize', 20);
        xlabel('Time (in S)', 'FontSize', 18);
        ylabel('Amplitude (in V)', 'FontSize', 18);
        xlim = [0 0.1];

      else
        error(["The parameter passed to the function" param " doesn't exist."]);
      endif
    endfunction

    function plot_line_code_power_spectrum(obj)
      if ~isa(obj, 'transmitter')
        error("Passed object is not of the transmitter type.");
      endif
      if isnull(obj.line_coded_stream)
        error("transmitter_object.line_code('line_coding_style', vcc) must be called first.");
      endif

      stream = repelem(obj.line_coded_stream, 50);
      N = length(stream);
      ts = 0.01;
      T = N * ts ;
      fs = 1 / ts;
      df = 1 / T;

      if(rem(N ,2)==0)
        frequencies = -(0.5*fs) : df : (0.5*fs - df);             %% Frequency vector if x/f is even
      else
        frequencies = -(0.5*fs - 0.5*df) : df : (0.5*fs - 0.5*df);%% Frequency vector if x/f is odd
      endif

      S =  (fftshift(fft(stream)))/N;

      plot(frequencies, abs(S.^2), 'Color', "#691d29");
      title(['Power spectrum of '  obj.line_coding_style  ' line-coded stream'], 'FontSize', 20);
      xlabel('Frequency', 'FontSize', 18);
      ylabel('Magnitude', 'FontSize', 18);
      axis([-4 4 0 (max(obj.line_coded_stream)/50)]); %heuristic
    endfunction

    function plot_bpsk_power_spectrum(obj)
      if ~isa(obj, 'transmitter')
        error("Passed object is not of the transmitter type.");
      endif
      if isnull(obj.bpsk_modulated)
        error("transmitter_object.bpsk() must be called first.");
      endif

      stream = obj.bpsk_modulated;
      N = length(stream);
      ts = 0.01;
      T = N * ts ;
      fs = 1 / ts;
      df = 1 / T;

      if(rem(N ,2)==0)
        frequencies = -(0.5*fs) : df : (0.5*fs - df);             %% Frequency vector if x/f is even
      else
        frequencies = -(0.5*fs - 0.5*df) : df : (0.5*fs - 0.5*df);%% Frequency vector if x/f is odd
      endif

      S =  (fftshift(fft(stream)))/N;

      plot(frequencies, abs(S.^2), 'Color', "#003003");
      title(['Power spectrum of BPSK-modulated stream'], 'FontSize', 20);
      xlabel('Frequency', 'FontSize', 18);
      ylabel('Magnitude', 'FontSize', 18);
      axis([-4 4 0 (max(obj.line_coded_stream)/50)]); %heuristic
    endfunction

    function plot_eyediagram(obj, chosen_stream)
      if (nargin < 2)
        chosen_stream = line_coded_stream
      elseif strcmp(chosen_stream, 'line_coded_stream') ~= 1 && strcmp(chosen_stream, 'stream') ~= 1
        error("The given parameter is not supported by this function. This function only supports 'stream' and 'line_coded_stream'");
      endif
      if (length(obj.(chosen_stream)) < 40)
        warning("plot_eyediagram doesn't work properly with a stream size of less than 20 bits.");
      endif
      if (obj.stream_size > 5000)
        warning("Stream size was capped to 5000 bits to speed up eyediagram generation.");
      endif
      hold on
      stream = obj.(chosen_stream)(1:min(obj.stream_size * 2, 5000));
      stream = [stream stream(length(stream))];
      stream = repelem(stream, 50);
      bit_time = obj.time_limit / (obj.stream_size - 1);
      for i = 1 : 300 : length(stream) - 300
        plot(stream(i : i + 299), 'Color', "#8a4f15", 'LineWidth', 1.25);
      endfor
%linspace(0, bit_time*4, 101),
      if strcmp(chosen_stream, 'line_coded_stream')
        title(['Eyediagram for ' obj.line_coding_style ' line-coded stream'], 'FontSize', 20);
        ylabel('Volt', 'FontSize', 18);
      else
        title('Eyediagram for transmitted 0/1 stream', 'FontSize', 20);
        ylabel('Data (0/1)', 'FontSize', 18);
      endif

      xlabel('Time', 'FontSize', 18);
      %axis([(0.99 * obj.time_limit / (3 * 4))  ((obj.time_limit/3) * 1.1)])
      axis([75 225])
      hold off
    endfunction
  endmethods
endclassdef


