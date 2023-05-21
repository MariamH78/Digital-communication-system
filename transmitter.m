classdef transmitter
  properties
    stream = [];
    time_limit = 0.0;
    line_coded_stream = [];
    bpsk_modulated = [];
    line_coding_style = '';
    stream_size = 0;

  endproperties

  methods
    function obj = transmitter (varargin)
      obj.stream = [];
      time_domain_vector = [];
      obj.line_coded_stream = [];
      obj.bpsk_modulated = [];
      obj.line_coding_style = '';
      obj.stream_size = 0;
    endfunction

    function obj = create_stream (obj, stream_size, bitrate)
      if ~isa(obj, 'transmitter')
        error("Passed object is not of the transmitter type.");
      endif
      if nargin < 3
          bitrate = 100;
      endif
      if nargin == 0 || nargin == 1 || (nargin >= 2 && stream_size == 0)
        temp = randi([0 1], 1, 10000);
        obj.stream = repelem(temp, 2);
        obj.stream_size = 10000;
        obj.time_limit = 10000.0 * 1/bitrate - 1/bitrate;
      else
        temp = randi([0 1], 1, stream_size);
        obj.stream = repelem(temp, 2);
        obj.stream_size = stream_size;
        obj.time_limit = stream_size * 1/bitrate - 1/bitrate;
      endif

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

      obj.line_coding_style = line_coding_style;

      if (strcmp(line_coding_style, "unrz") == 1)
        obj.line_coded_stream = zeros (1, obj.stream_size * 2);
        for i = 1 : obj.stream_size * 2
          if (obj.stream(i) == 1)
            obj.line_coded_stream(i) = vcc_positive;
          endif
        endfor
      elseif (strcmp(line_coding_style, "urz") == 1)
        obj.line_coded_stream = zeros (1, obj.stream_size * 2);
        for i = 1 : obj.stream_size * 2
          if (obj.stream(i) == 1 && (mod(i, 2) == 1))
            obj.line_coded_stream(i) = vcc_positive;
          endif
        endfor

      elseif (strcmp(line_coding_style, "pnrz") == 1)
        if nargin < 4
          vcc_negative = vcc_positive * -1;
        endif

        obj.line_coded_stream = zeros (1, obj.stream_size * 2);
        for i = 1 : obj.stream_size * 2
          if (obj.stream(i) == 1)
            obj.line_coded_stream(i) = vcc_positive;
          else
            obj.line_coded_stream(i) = vcc_negative;
          endif
        endfor

     elseif (strcmp(line_coding_style, "prz") == 1)
        if nargin < 4
          vcc_negative = vcc_positive * -1;
        endif

        obj.line_coded_stream = zeros (1, obj.stream_size * 2);
        for i = 1 : obj.stream_size * 2
          if (obj.stream(i) == 1 && (mod(i, 2) == 1))
            obj.line_coded_stream(i) = vcc_positive;
          elseif mod(i, 2) == 1
            obj.line_coded_stream(i) = vcc_negative;
          endif
        endfor

      elseif (strcmp(line_coding_style, "bpnrz") == 1)
        if nargin < 4
          vcc_negative = vcc_positive * -1;
        endif

        flag = 1;
        obj.line_coded_stream = zeros (1, obj.stream_size * 2);
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

      elseif (strcmp(line_coding_style, "bprz") == 1)
        if nargin < 4
          vcc_negative = vcc_positive * -1;
        endif

        flag = 1;
        obj.line_coded_stream = zeros (1, obj.stream_size * 2);
        for i = 1 : obj.stream_size * 2
          if (obj.stream(i) == 1 && flag && (mod(i, 2) == 1))
            obj.line_coded_stream(i) = vcc_positive;
            flag = 0;
          elseif (obj.stream(i) == 1 && ~flag && (mod(i, 2) == 1))
            obj.line_coded_stream(i) = vcc_negative;
            flag = 1;
          endif
        endfor

      elseif (strcmp(line_coding_style, "manchester") == 1)
        if nargin < 4
          vcc_negative = vcc_positive * -1;
        endif

        obj.line_coded_stream = zeros (1, obj.stream_size * 2);
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
      endif
    obj.line_coded_stream = [obj.line_coded_stream  obj.line_coded_stream(length(obj.line_coded_stream))];

    endfunction

    function obj = bpsk (obj)
      if ~isa(obj, 'transmitter')
        error("Passed object is not of the transmitter type.");
      endif
      if isnull(obj.line_coded_stream) || strcmp(obj.line_coding_style, 'pnrz') ~= 1
        error("transmitter_object.line_code('pnrz', vcc) must be called first.");
      endif

      obj.bpsk_modulated = zeros(1, obj.stream_size * 2/0.01);
      temp = repelem(obj.line_coded_stream(1 : length(obj.line_coded_stream) - 1), 100);
      for i = 1 : length(temp)
        obj.bpsk_modulated (i) = cos(2 * 3.14159265  * 10000000 * i) * temp(i);
      endfor
    endfunction

  endmethods
endclassdef


