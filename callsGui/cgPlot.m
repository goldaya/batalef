function [  ] = cgPlot(  )
%CGPLOT Put call data on screen

    % stats
    cgRefreshStats();
    
    % envelope with colors
    try
        cgPlotEnvelope();
    catch
    end

    % time-series
    cgPlotTS()
    
    % spectral data
    cgPlotSpectrogram();
    cgPlotSpectrum();

end

