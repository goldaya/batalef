function [  ] = cgPlotEnvelope( rawDataset,T )
%CGPLOTENVELOPE Summary of this function goes here
%   Detailed explanation goes here

    global control;
    handles = cgGetHandles();
    call = control.cg.call;
    
    % get envelope
    envDataset = envmAdminCompute(rawDataset,call.Fs);
    envDataset = 20.*log10(envDataset);

    
    %translate into points
    dpoint = find((T<=call.DetectionTime),1,'last'); 
    if isempty(dpoint)
        cla(handles.axesCallWindow);
    end
    spoint = find((T<=call.StartTime),1,'last');
    if isempty(spoint)
        spoint = dpoint;
    end
    epoint = find((T<=call.EndTime),1,'last'); 
    if isempty(epoint)
        epoint = dpoint;
    end

    ppoint = find((T<=call.PeakTime),1,'last'); 
    
    % plot
    N = length(envDataset);    
    plot(handles.axesCallWindow, T(1:spoint),envDataset(1:spoint),'b');
    hold(handles.axesCallWindow, 'on');
    plot(handles.axesCallWindow, T(spoint:epoint), envDataset(spoint:epoint), 'r');
    plot(handles.axesCallWindow, T(epoint:N), envDataset(epoint:N),'b');
    plot(handles.axesCallWindow, T(dpoint), 20*log10(call.DetectionValue), 'y*');
    if ~isempty(ppoint)
        plot(handles.axesCallWindow, T(ppoint), 20*log10(call.PeakValue), 'g*');
    end
    hold(handles.axesCallWindow, 'off');
    axis(handles.axesCallWindow, 'tight');
    xlabel(handles.axesCallWindow, {'Red Curve = Realised Call', 'Green Mark = Local Peak ; Yellow Mark = Detection'});    
    %set(handles.axesCallWindow, 'XLim', [T(1),T(N)]);
    %set(handles.axesCallWindow, 'YLim', [min(envDataset),max(envDataset)]);
    
end

