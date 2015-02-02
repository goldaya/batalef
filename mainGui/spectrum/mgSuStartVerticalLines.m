function [  ] = mgSuStartVerticalLines( hObject, Rx, Ry )
%MGSUSTARTVERTICALLINES 

    global control;

    if ~ishandle(hObject)
        return;
    end
    
    % compute time measure from Rx
    xlim = get(hObject, 'XLim');
    dt = (xlim(2)-xlim(1))*Rx;
    time = xlim(1) + dt;
    
    % show vertical lines
    mgSuShowVerticalLines( time, 'start' );
    
    % keep time coordinate
    control.mg.su.startTime = time;
end

