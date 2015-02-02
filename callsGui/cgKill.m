function [  ] = cgKill(  )
%CGKILL Destroy Calls gui

    global control;
    if ~isempty(control.cg.fig)
        if ishandle(control.cg.fig)
            delete(control.cg.fig);
        end
        control.cg.fig = [];
    end

end

