function [  ] = mcgKill(  )
%MCGKILL Summary of this function goes here
%   Detailed explanation goes here

global control;

if ~isempty(control.mcg.fig) 
   
    if ishandle(control.mcg.fig)
        delete(control.mcg.fig)
    end
    
    control.mcg.fig = [];
    control.mcg.K = [];
    
end
    
end

