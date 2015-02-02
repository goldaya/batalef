function [ output_args ] = sogTmStartVerticalLines( hObject, Rx, Ry )
%SOGTMSTARTVERTICALLINES 

    global control;

    if ~ishandle(hObject)
        return;
    end
    
    % compute time measure from Rx
    xlim = get(hObject, 'XLim');
    dt = (xlim(2)-xlim(1))*Rx;
    time = xlim(1) + dt;
    
    % show vertical lines
    sogTmShowVerticalLines( time, 'start' );
    
    % keep time coordinate
    control.sog.tm.startTime = time;
end

