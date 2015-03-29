function [  ] = mgRmStartVerticalLines( hObject, Rx, Ry )
%MGRMSTARTVERTICALLINES 

    global control;

    if ~ishandle(hObject)
        return;
    end
    
    % compute time measure from Rx
    xlim = get(hObject, 'XLim');
    dt = (xlim(2)-xlim(1))*Rx;
    time = xlim(1) + dt;
    
    % show vertical lines
    mgRmShowVerticalLines( time, 'start' );
    
    % keep time coordinate
    control.mg.Rm.startTime = time;
end

