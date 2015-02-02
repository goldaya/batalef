function [ output_args ] = mgTmEndVerticalLines( hObject, Rx, Ry )
%MGTMENDVERTICALLINES Summary of this function goes here
%   Detailed explanation goes here

    global control;
    
    % compute time measure from Rx
    xlim = get(hObject, 'XLim');
    dt = (xlim(2)-xlim(1))*Rx;
    time = xlim(1) + dt;
    
    % show vertical lines
    mgTmShowVerticalLines( time, 'end' );
    
    % keep time coordinate
    control.mg.tm.endTime = time;

end

