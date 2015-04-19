function cgPlotSpectrum(  )
%CGPLOTSPECTRUM Summary of this function goes here
%   Detailed explanation goes here

    global control;
    handles = cgGetHandles();
    
    S = control.cg.call.SpectralData;
    if isempty(S)
        wip = control.cg.call.inPoints(control.cg.call,[control.cg.call.StartTime,control.cg.call.EndTime]);
        if wip(2) > wip(1)
            dataset = channelData(control.cg.call.FileIdx,control.cg.call.ChannelIdx,'TS','Interval',wip,'Filter',control.cg.filter);
            S = sumAdminCompute(dataset, control.cg.call.Fs);
        end
    end
    
    try
        plot(handles.axesCallSpectrum, S.F, S.P);
        ylabel(handles.axesCallSpectrum, {'Spectrum','Gain: dB'});
        xlabel(handles.axesCallSpectrum, 'Frequency: Hz');
        axis(handles.axesCallSpectrum,'tight');        
    catch err
        cla(handles.axesCallSpectrum);
    end

end

