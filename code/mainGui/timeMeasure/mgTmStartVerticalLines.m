function [ output_args ] = mgTmStartVerticalLines( hObject, Rx, Ry )
%MGTMSTARTVERTICALLINES Summary of this function goes here
%   Detailed explanation goes here

    global control;

    if ~ishandle(hObject)
        return;
    end
    
    % compute time measure from Rx
    xlim = get(hObject, 'XLim');
    dt = (xlim(2)-xlim(1))*Rx;
    time = xlim(1) + dt;
    
    % show vertical lines
    mgTmShowVerticalLines( time, 'start' );
    
    % keep time coordinate
    control.mg.tm.startTime = time;
end

