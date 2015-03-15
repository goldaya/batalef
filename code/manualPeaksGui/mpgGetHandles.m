function [ handles, objHandle ] = mpgGetHandles( objName )
%MPGGETHANDLES Summary of this function goes here
%   Detailed explanation goes here

    global control;
    handles = guidata(control.mpg.fig);
    if exist('objName','var') && isfield(handles, objName)
        objHandle = handles.(objName);
    end
    
end

