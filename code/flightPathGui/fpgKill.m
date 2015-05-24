function [  ] = fpgKill(  )
%FPGKILL Summary of this function goes here
%   Detailed explanation goes here
    
    global control;
    
    bmgKill();
    if ~isempty(control.fpg.fig)
        if ishandle(control.fpg.fig)
            delete(control.fpg.fig);
        end
        control.fpg.fig = [];
    end
    
end

