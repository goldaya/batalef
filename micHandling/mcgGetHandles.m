function [ handles, objHandle ] = mcgGetHandles( objName )
%MCGGETHANDLES Summary of this function goes here
%   Detailed explanation goes here

    global control;
    handles = guidata(control.mcg.fig);
    if exist('objName','var') && isfield(handles, objName)
        objHandle = handles.(objName);
    end    

end

