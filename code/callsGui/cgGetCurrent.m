function [ k,j,s ] = cgGetCurrent(  )
%CGGETCURRENT Get the current indexes

    global control;
    k = control.cg.k;
    j = control.cg.j;
    s = control.cg.s;

end

