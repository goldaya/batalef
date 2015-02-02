function [ output_args ] = mpgKill( input_args )
%MPGKILL Summary of this function goes here
%   Detailed explanation goes here

global control;
h = control.mpg.fig;
control.mpg.fig = [];
delete(h);
mgAssignAxesFunctions('','');
control.mpg.peak = [];

end

