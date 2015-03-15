function [  ] = sugKill(  )
%SUGKILL Destroy spectrum gui

global control;
if ~isfield(control, 'sug') || isempty(control.sug) || ~isfield(control.sug, 'fig')
    return;
end

if ishandle(control.sug.fig)
    delete(control.sug.fig);
end
control.sug.fig = [];
mgAssignAxesFunctions('','');

end

