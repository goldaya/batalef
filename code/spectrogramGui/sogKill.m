function [  ] = sogKill(  )
%SOGKILL Destroy Spectro gui

global control;
mgSoClearVerticalLines();
delete(control.sog.fig);
control.sog.fig = [];



end

