clear
clc

%recevier();
graphics_toolkit('fltk')
tee = transmitter();
tee = create_stream(tee, 10000);
tee = tee.line_code("manchester", 1.2);
%tee = tee.bpsk();

a=tee.stream;
b=tee.line_coded_stream;

if (strcmp(tee.line_coding_style,'unrz')==1)
  for i = 1 : tee.stream_size * 2
      if ((tee.line_coded_stream(i)) > 0.6)
       rx_signal(i)=1;
      endif
  endfor
endif


if (strcmp(tee.line_coding_style,'urz')==1)
   rx_signal= zeros (1, tee.stream_size * 2);
  for i = 1 : tee.stream_size*2
      if (tee.line_coded_stream(i) > 0.6 && tee.line_coded_stream(i+1) ==0 )
       rx_signal(i)=rx_signal(i+1)=1;
      endif
  endfor
endif

if (strcmp(tee.line_coding_style,'pnrz')==1)
  for i = 1 : tee.stream_size*2
      if (tee.line_coded_stream(i) > 0 )
       rx_signal(i)=1;
      else
       rx_signal(i)=0;
      endif
  endfor
endif


if (strcmp(tee.line_coding_style,'prz')==1)
  for i = 1 : tee.stream_size*2
      if (tee.line_coded_stream(i) > 0 && tee.line_coded_stream(i+1) == 0 )
       rx_signal(i)=rx_signal(i+1)=1;
      elseif (tee.line_coded_stream(i) < 0 && tee.line_coded_stream(i+1) == 0 )
       rx_signal(i)=rx_signal(i+1)=0;
      endif
  endfor
endif


if (strcmp(tee.line_coding_style,'bpnrz')==1)
  for i = 1 : tee.stream_size*2
      if (tee.line_coded_stream(i) > 0 || tee.line_coded_stream(i) < 0 )
       rx_signal(i)=1;
      elseif
       rx_signal(i)=0;
      endif
  endfor
endif

if (strcmp(tee.line_coding_style,'bprz')==1)
     rx_signal= zeros (1, tee.stream_size * 2);
  for i = 1 : tee.stream_size*2
      if (tee.line_coded_stream(i)>0 || tee.line_coded_stream(i) < 0 )
       rx_signal(i) = rx_signal(i+1)=1;
      endif
  endfor
endif

if (strcmp(tee.line_coding_style,'manchester')==1)
   rx_signal= zeros (1, tee.stream_size * 2);
  for i = 1 : tee.stream_size*2
      if (tee.line_coded_stream(i) > 0 && tee.line_coded_stream(i+1) < 0 )
       rx_signal(i)=rx_signal(i+1)=1;
      endif
  endfor
endif

stairs(tee.stream);




