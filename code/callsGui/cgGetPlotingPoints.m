function [ spoint, epoint ] = cgGetPlotingPoints(  )
%CGGETPLOTINGPOINTS Summary of this function goes here
%   Detailed explanation goes here

    global control;
    [k,j,~] = cgGetCurrent();
    handles = cgGetHandles();
    Fs = channelData(k,j,'Fs');
    call = control.cg.call;
    
    dp = round( str2double(get(handles.textCallWindow, 'String'))/1000 * Fs );
    spoint = round( call.DetectionPoint - dp/2 );
    epoint = round( call.DetectionPoint + dp/2 );
end

