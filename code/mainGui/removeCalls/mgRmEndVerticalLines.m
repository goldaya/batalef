function [  ] = mgRmEndVerticalLines( hObject, Rx, Ry )
%MGRMENDVERTICALLINES 

    global control;
    
    % compute time measure from Rx
    xlim = get(hObject, 'XLim');
    dt = (xlim(2)-xlim(1))*Rx;
    time = xlim(1) + dt;
    
    % show vertical lines
    mgRmShowVerticalLines( time, 'end' );
    
    % keep time coordinate
    control.mg.Rm.endTime = time;

end

