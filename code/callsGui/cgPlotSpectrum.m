function cgPlotSpectrum(  )
%CGPLOTSPECTRUM Summary of this function goes here
%   Detailed explanation goes here

    global control;
    handles = cgGetHandles();
    
    S = control.cg.call.SpectralData;
    
    if isempty(S.P)
        cla(handles.axesCallSpectrum);
    else
        plot(handles.axesCallSpectrum, S.F, S.P);
    end
    ylabel(handles.axesCallSpectrum, {'Spectrum','Gain: dB'});
    xlabel(handles.axesCallSpectrum, 'Frequency: Hz');
    axis(handles.axesCallSpectrum,'tight');

end

