function [ handles, objHandle ] = mgGetHandles( objName )
%MGGETHANDLES Get handles of main GUI
	
    global control;
    handles = guidata(control.mg.fig);
    if exist('objName','var') && isfield(handles, objName)
        objHandle = handles.(objName);
    end
    

end

