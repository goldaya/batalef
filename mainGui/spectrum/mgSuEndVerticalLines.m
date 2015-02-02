function [ output_args ] = mgSuEndVerticalLines( hObject, Rx, Ry )
%MGSOENDVERTICALLINES 

    global control;
    
    % compute time measure from Rx
    xlim = get(hObject, 'XLim');
    dt = (xlim(2)-xlim(1))*Rx;
    time = xlim(1) + dt;
    
    % show vertical lines
    mgSuShowVerticalLines( time, 'end' );
    
    % keep time coordinate
    control.mg.su.endTime = time;

end

