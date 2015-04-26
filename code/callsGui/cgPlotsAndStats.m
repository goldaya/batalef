function cgPlotsAndStats( dataset,T )
%CGPLOTSANDSTATS -INTERNAL- Reresh the plots and stats on the calls gui

    global control;

    % stats
    cgRefreshStats();
    
    % get dataset
    if ~exist('dataset','var') || isempty(dataset)
        [dataset,T] = channelData(control.cg.call.k, control.cg.call.j, 'TS', ...
            channelCall.inPoints(control.cg.call,control.cg.window),...
            'Filter',control.cg.filter);
    end
    
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

