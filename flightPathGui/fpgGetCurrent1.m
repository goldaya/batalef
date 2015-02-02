function [ k, j, s ] = fpgGetCurrent(  )
%FPGGETCURRENT Get current indexes

    global control;
    k = control.fpg.k;
    j = control.fpg.j;
    s = control.fpg.s;

end

