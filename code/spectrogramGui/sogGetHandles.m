function [ handles, objHandle ] = sogGetHandles( objName )
%SOGGETHANDLES Summary of this function goes here
%   Detailed explanation goes here

    global control;
    handles = guidata(control.sog.fig);
    if exist('objName','var') && isfield(handles, objName)
        objHandle = handles.(objName);
    end
    
end

