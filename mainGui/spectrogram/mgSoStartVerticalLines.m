function [  ] = mgSoStartVerticalLines( hObject, Rx, Ry )
%MGSOSTARTVERTICALLINES 

    global control;

    if ~ishandle(hObject)
        return;
    end
    
    % compute time measure from Rx
    xlim = get(hObject, 'XLim');
    dt = (xlim(2)-xlim(1))*Rx;
    time = xlim(1) + dt;
    
    % show vertical lines
    mgSoShowVerticalLines( time, 'start' );
    
    % keep time coordinate
    control.mg.so.startTime = time;
end

