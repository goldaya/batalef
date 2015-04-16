function [  ] = cgPlotTS( dataset, T )
%CGPLOTTS Summary of this function goes here
%   Detailed explanation goes here

    global control;
    handles = cgGetHandles();
    call = control.cg.call;
    
    % take only the realised call part of the dataset
    spoint = find((T<=call.StartTime),1,'last');
    epoint = find((T<=call.EndTime),1,'last');    
    
    if length(T) > 1 && epoint > spoint
        plot(handles.axesCallTS, T(spoint:epoint),dataset(spoint:epoint));
    else
        cla(handles.axesCallTS);
    end
    axis(handles.axesCallTS, 'tight');
    ylabel(handles.axesCallTS, {'Time Series','Signal Power'});
    xlabel(handles.axesCallTS, {'Time: seconds'});

end