clear
clc
tee = transmitter();
rx_signal=[];
 function recevied = rec(line_coding_style)
        if (strcmp(line_coding_style,'unrz')==1)
          for i = 1 : tee.stream_size * 2
              if ((tee.line_coded_stream(i)) > 0.6)
               rx_signal(i)=1;
              endif
          endfor
        endif
endfunction





