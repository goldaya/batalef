function [  ] = pwpdgKill(  )
%PWPDGKILL Kill the pwpd gui
    global control;
    if isempty(control.pwpdg) || isempty(control.pwpdg.fig)
        return;
    end
    if ishandle(control.pwpdg.fig)
        delete(control.pwpdg.fig);
    end
    control.pwpdg.fig = [];
    pwpdgShowIntervals(false);
    mgMpwpdClearVerticalLines();
    
end

