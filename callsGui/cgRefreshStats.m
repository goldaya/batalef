function [ output_args ] = cgRefreshStats( input_args )
%CGREFRESHSTATS Summary of this function goes here
%   Detailed explanation goes here

    global control;
    call = control.cg.call;
    handles = cgGetHandles();
    
    
    set(handles.textStartPoint, 'String',num2str(call.StartPoint));
    set(handles.textStartTime, 'String',num2str(call.StartTime*1000));
    set(handles.textPeakPoint, 'String',num2str(call.PeakPoint));
    set(handles.textPeakTime, 'String',num2str(call.PeakTime*1000));
    set(handles.textEndPoint, 'String',num2str(call.EndPoint));
    set(handles.textEndTime, 'String',num2str(call.EndTime*1000));
    set(handles.textDuration, 'String',num2str(call.Duration*1000));
    set(handles.textDurationPoint, 'String',num2str(call.nPoints));
    set(handles.textDetectionPoint, 'String',num2str(call.DetectionPoint));
    set(handles.textDetectionTime, 'String',num2str(call.DetectionTime*1000));
    set(handles.textDeltaPoints,'String',num2str(call.ipiPoints));
    set(handles.textDeltaTime,'String',num2str(call.ipiTime*1000));
end

