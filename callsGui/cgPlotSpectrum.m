function cgPlotSpectrum(  )
%CGPLOTSPECTRUM Summary of this function goes here
%   Detailed explanation goes here

    global control;
    handles = cgGetHandles();
    try
        [P,F] = control.cg.call.computeSpectrum();
    catch err
        P = [];
    end
    if isempty(P)
        cla(handles.axesCallSpectrum);
    else
        plot(handles.axesCallSpectrum, F, P);
    end
    ylabel(handles.axesCallSpectrum, {'Spectrum','Gain: dB'});
    xlabel(handles.axesCallSpectrum, 'Frequency: Hz');
    axis(handles.axesCallSpectrum,'tight');

end

