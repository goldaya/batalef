function [ handles ] = fpgGetHandles(  )
%FPGGETHANDLES Get handles of flight path gui

    global control;
    handles = guidata(control.fpg.fig);


end

