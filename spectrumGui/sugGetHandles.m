function [ handles, objHandle ] = sugGetHandles( objName )
%SUGGETHANDLES Summary of this function goes here
%   Detailed explanation goes here

    global control;
    handles = guidata(control.sug.fig);
    if exist('objName','var') && isfield(handles, objName)
        objHandle = handles.(objName);
    end
    
end

