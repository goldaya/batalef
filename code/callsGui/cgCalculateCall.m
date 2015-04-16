function [  ] = cgCalculateCall(  )
%CGCALCULATECALL Calculate start and end of call, spectral data, and plot
%stuff

    global control;
    [k,j,s,t] = cgGetCurrent;
    handles   = cgGetHandles();
    call      = control.cg.call;
    
    % window to work in
    dt = str2double(get(handles.textCallWindow, 'String'))/1000 ;
    window = [call.DetectionTime-dt/2, call.DetectionTime+dt/2];
    
    % parameters for call interval realization
    startThreshold = str2double(get(handles.textStartDiff,'String'));
    endThreshold   = str2double(get(handles.textEndDiff,  'String'));
    gapTolerance = str2double(get(handles.textGap, 'String'))/1000;
    
    % analyze call
    call = channelCallAnalyze(k,j,s,t,window,[],startThreshold,endThreshold,gapTolerance,true,true);
    control.cg.call = call;
    

end

