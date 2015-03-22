function mpgKill(  )
%MPGKILL - INTERNAL - deassign axes functions and destroy manual peaks detection gui

global control;
h = control.mpg.fig;
control.mpg.fig = [];
delete(h);
mgAssignAxesFunctions('','');
control.mpg.peak = [];

end

