function call = cgCalculateCall( forcedBoundries )
%CGCALCULATECALL Calculate start and end of call, spectral data, and plot
%stuff

    global control;
    [k,j,s,t] = cgGetCurrent;
    handles   = cgGetHandles();
    
 
    % parameters for call interval realization
    startThreshold = str2double(get(handles.textStartDiff,'String'));
    endThreshold   = str2double(get(handles.textEndDiff,  'String'));
    gapTolerance = str2double(get(handles.textGap, 'String'))/1000;
    
    %
    if ~exist('forcedBoundries','var')
        forcedBoundries = [];
    end
    
    % analyze call
    call = channelCallAnalyze(k,j,s,t,control.cg.window,[],[],startThreshold,endThreshold,gapTolerance,forcedBoundries,true,true);
    control.cg.call = call;
    

end

