function [ output_args ] = cgPlotEnvelope( input_args )
%CGPLOTENVELOPE Summary of this function goes here
%   Detailed explanation goes here

    global control;
    [k,j] = cgGetCurrent();
    handles = cgGetHandles();
    call = control.cg.call;
    
    [a,b] = cgGetPlotingPoints();
    [dataset,T] = channelData(k, j, 'Envelope', [a,b]);
    
    spoint = call.StartPoint - a;
    epoint = call.EndPoint - a;
    
    N = length(dataset);
    plot(handles.axesCallWindow, T(1:spoint),dataset(1:spoint),'b');
    hold(handles.axesCallWindow, 'on');
    plot(handles.axesCallWindow, T(spoint:epoint), dataset(spoint:epoint), 'r');
    plot(handles.axesCallWindow, T(epoint:N), dataset(epoint:N),'b');
    plot(handles.axesCallWindow, T(call.DetectionPoint - a), call.DetectionValue, 'g*');
    hold(handles.axesCallWindow, 'off');
    set(handles.axesCallWindow, 'XLim', [T(1),T(N)]);
    set(handles.axesCallWindow, 'YLim', [min(dataset),max(dataset)]);
    
end

