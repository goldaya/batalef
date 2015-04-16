function [  ] = cgPlotEnvelope( rawDataset,T )
%CGPLOTENVELOPE Summary of this function goes here
%   Detailed explanation goes here

    global control;
    handles = cgGetHandles();
    call = control.cg.call;
    
    % get envelope
    envDataset = envmAdminCompute(rawDataset,call.Fs);
    
    %translate into points
    spoint = find((T<=call.StartTime),1,'last');
    epoint = find((T<=call.EndTime),1,'last'); 
    dpoint = find((T<=call.DetectionTime),1,'last'); 
    ppoint = find((T<=call.PeakTime),1,'last'); 
    
    % plot
    N = length(envDataset);
    plot(handles.axesCallWindow, T(1:spoint),envDataset(1:spoint),'b');
    hold(handles.axesCallWindow, 'on');
    plot(handles.axesCallWindow, T(spoint:epoint), envDataset(spoint:epoint), 'r');
    plot(handles.axesCallWindow, T(epoint:N), envDataset(epoint:N),'b');
    plot(handles.axesCallWindow, T(dpoint), call.DetectionValue, 'y*');
    plot(handles.axesCallWindow, T(ppoint), call.PeakValue, 'g*');
    hold(handles.axesCallWindow, 'off');
    set(handles.axesCallWindow, 'XLim', [T(1),T(N)]);
    set(handles.axesCallWindow, 'YLim', [min(envDataset),max(envDataset)]);
    
end

