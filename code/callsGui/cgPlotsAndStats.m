function cgPlotsAndStats( )
%CGPLOTSANDSTATS -INTERNAL- Reresh the plots and stats on the calls gui

    global control;

    % stats
    cgRefreshStats();
    
    % get dataset
    dataset = control.cg.TS(control.cg.wip(1):control.cg.wip(2));
    T = control.cg.T(control.cg.wip(1):control.cg.wip(2));
        
    % envelope with colors
    try
        cgPlotEnvelope(dataset,T);
    catch err
        err.message;
    end

    % time-series
    cgPlotTS(dataset,T)
    
    % spectral data
    cgPlotSpectrogram();
    cgPlotSpectrum();

end

