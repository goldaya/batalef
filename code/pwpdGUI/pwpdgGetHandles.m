function [ handles, objHandle ] = pwpdgGetHandles( objName )
%PWPDGGETHANDLES Summary of this function goes here
%   Detailed explanation goes here

    global control;
    handles = guidata(control.pwpdg.fig);
    if exist('objName','var') && isfield(handles, objName)
        objHandle = handles.(objName);
    end
    
end

