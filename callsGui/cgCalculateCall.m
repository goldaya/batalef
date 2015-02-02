function [  ] = cgCalculateCall(  )
%CGCALCULATECALL Calculate start and end of call, spectral data, and plot
%stuff

    global control;
    [k,j,~] = cgGetCurrent();
    handles = cgGetHandles();
    Fs = channelData(k,j,'Fs');
    call = control.cg.call;
    
    startRelativeThreshold = 1 - get(handles.sliderStartDiff, 'Value');
    endRelativeThreshold = 1 - get(handles.sliderEndDiff, 'Value');
    gapTolerance = str2double(get(handles.textGap, 'String'))/1000*Fs;
    dp = round( str2double(get(handles.textCallWindow, 'String'))/1000 * Fs );
    calculateCall( call, true, dp, startRelativeThreshold,endRelativeThreshold,gapTolerance);
    

end

