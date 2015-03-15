function [  ] = cgManualCallRealization( surfobj, ~ )
%CGMANUALCALLREALIZATION Summary of this function goes here
%   Detailed explanation goes here

    global control;
    handles = cgGetHandles();
    
    % get axes object
    axobj = get(surfobj,'Parent');
    
    % rubberand selection
    point1 = get(axobj,'CurrentPoint');
    rbbox;
    point2 = get(axobj,'CurrentPoint');
    
    call = control.cg.call;
    Fs = call.Fs;
    startPoint = round(point1(1,1)*Fs);
    endPoint = round(point2(1,1)*Fs);
    
    % REALISE CALL
    call.forceCallBoundries(startPoint,endPoint);
    
    % get spectral info - uses somAdminCompute inside
    dp = round( str2double(get(handles.textCallWindow, 'String'))/1000 * Fs );
    spoint = round( call.DetectionPoint - dp/2 );
    epoint = round( call.DetectionPoint + dp/2 );
    if spoint < 1
        spoint = 1;
    end
    if epoint > fileData(call.k,'nSamples','NoValidation')
        epoint = fileData(call.k,'nSamples','NoValidation');
    end    
    call.computeSpectralData([spoint,epoint]);
    
    % ridge
    call.computeRidge();
    
    % set sliders
    peakValue = call.PeakValue;
    s = 1 - call.StartValue / peakValue;
    dB = 10*log10(1-s);
    set(handles.sliderStartDiff, 'Value', s ) ;
    set(handles.textStartDiff,'String',num2str(dB));
    
    s = 1 - call.EndValue / peakValue;
    dB = 10*log10(1-s);
    set(handles.sliderEndDiff, 'Value', s ) ;
    set(handles.textEndDiff,'String',num2str(dB));
    
    % the gap is arbitrary and might be wrong. consider future dev.
    set(handles.textGap,'String','0.3');
    set(handles.sliderGap, 'Value', 0.3);
    
    % replot
    cgPlot();
end

