function [  ] = cgManualCallRealization( surfobj, ~ )
%CGMANUALCALLREALIZATION Summary of this function goes here
%   Detailed explanation goes here

    handles = cgGetHandles();
    
    % get axes object
    axobj = get(surfobj,'Parent');
    
    % rubberand selection
    point1 = get(axobj,'CurrentPoint');
    rbbox;
    point2 = get(axobj,'CurrentPoint');

    call = cgCalculateCall( [point1(1,1),point2(1,1)] );
      
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
    cgPlotsAndStats();
    
end

