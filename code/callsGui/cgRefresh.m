function [  ] = cgRefresh(  )
%CGREFRESH Refresh all sliders, plots and stuff


    global control;
    handles = cgGetHandles();
    
    % recalculate call boundries
    if get(handles.rbValuesCalculated, 'Value') || ( get(handles.rbValuesMix,'Value') && ~control.cg.call.Saved )
        % calculate call data from GUI !
        cgCalculateCall();
    end
    
    % put on gui
    % stats
    cgRefreshStats();
    
    % get dataset
    [dataset,T] = channelData(control.cg.call.k, control.cg.call.j, 'TS', channelCall.inPoints(control.cg.call,control.cg.window));
    
    % envelope with colors
    try
        cgPlotEnvelope(dataset,T);
    catch
    end

    % time-series
    cgPlotTS(dataset,T)
    
    % spectral data
    cgPlotSpectrogram();
    cgPlotSpectrum();

    
    
end

