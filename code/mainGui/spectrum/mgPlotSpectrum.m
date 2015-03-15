function [  ] = mgPlotSpectrum( h,Rx,Ry )
%MGPLOTSPECTRUM Get the time position to plot spectrum for

    % get time coordinate
    xl = get(h, 'xlim');
    tc = xl(1) + Rx*diff(xl);
    % translate to point
    pc = tc*fileData(appData('Files','Displayed'),'Fs');
    
    % plot on spectrum gui
    sugPlot( pc );
    
    % show lines on axes
    mgSuShowVerticalLines( tc, 'start' );
    
end

