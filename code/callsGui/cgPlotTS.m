function [  ] = cgPlotTS(  )
%CGPLOTTS Summary of this function goes here
%   Detailed explanation goes here

    global control;
    [k,j,~] = cgGetCurrent();
    handles = cgGetHandles();
    call = control.cg.call;
    
    [TS,T] = channelData(k,j,'TS',[call.StartPoint, call.EndPoint]);
    if length(T) > 1
        plot(handles.axesCallTS, T,TS);
    else
        cla(handles.axesCallTS);
    end
    axis(handles.axesCallTS, 'tight');
    ylabel(handles.axesCallTS, {'Time Series','Signal Power'});
    xlabel(handles.axesCallTS, {'Time: seconds'});


end

