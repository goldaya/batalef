function [ k, fileCall, baseChannel, baseCall ] = fpgGetCurrent(  )
%FPGGETCURRENT Returns current file, base channel, base call, file call

    global control;
   

    % file idx
    k = control.fpg.k;
    if nargout == 1
        return;
    end

    % file call
    fileCall = control.fpg.a;
    if nargout == 2
        return;
    end
    
    handles = fpgGetHandles();
    % base channel
    bcStr = get(handles.ddBaseChannel, 'String');
    bcVal = get(handles.ddBaseChannel, 'Value');
    baseChannel = str2double(bcStr(bcVal));
    if nargout == 3
        return;
    end
    
    % base call
    v = get(handles.ddBaseCall, 'Value');
    S = get(handles.ddBaseCall, 'String');
    baseCall = str2double(S(v));

end

