function cgPlotsAndStats(  )
%CGPLOTSANDSTATS -INTERNAL- Reresh the plots and stats on the calls gui

    global control;

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

