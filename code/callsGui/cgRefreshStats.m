function cgRefreshStats()
%CGREFRESHSTATS - INTERNAL - in call data gui, refresh call statistical
%data

    global control;
    call = control.cg.call;
    handles = cgGetHandles();
    
    set(handles.textStartPoint, 'String',num2str(call.StartValue));
    set(handles.textStartTime, 'String',num2str(call.StartTime*1000));
    set(handles.textPeakPoint, 'String',num2str(call.PeakValue));
    set(handles.textPeakTime, 'String',num2str(call.PeakTime*1000));
    set(handles.textEndPoint, 'String',num2str(call.EndValue));
    set(handles.textEndTime, 'String',num2str(call.EndTime*1000));
    set(handles.textDuration, 'String',num2str(call.Duration*1000));
    set(handles.textDetectionPoint, 'String',num2str(call.DetectionValue));
    set(handles.textDetectionTime, 'String',num2str(call.DetectionTime*1000));
    set(handles.textDeltaTime,'String',num2str(call.IPI*1000));
    set(handles.textStartFreq, 'String', call.StartFreq);
    set(handles.textPeakFreq, 'String', call.PeakFreq);
    set(handles.textEndFreq, 'String', call.EndFreq);       
    
end

