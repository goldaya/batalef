function [  ] = cgPlot(  )
%CGPLOT Put call data on screen
    
    throwup();
    
    global control;
    call = control.cg.call;
    
    % stats
    cgRefreshStats();
    
    % get dataset
    [dataset,T] = channelData(call.k, call.j, 'TS', call.inPoints(call,control.cg.window));
    
    % envelope with colors
    try
        cgPlotEnvelope(dataset,T);
    catch
    end

    % time-series
    cgPlotTS(dataset,T)
    
    % spectral data
    %cgPlotSpectrogram();
    %cgPlotSpectrum();

end

