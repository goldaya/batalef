function [ handles, objHandle ] = cgGetHandles( objName )
%CGGETHANDLES Get handles of calls-gui

    global control;
    handles = guidata(control.cg.fig);
    if exist('objName','var') && isfield(handles, objName)
        objHandle = handles.(objName);
    end

end

