function [ k, baseChannel, baseCall, fileCall ] = fpgGetCurrent(  )
%FPGGETCURRENT Returns current file, base channel, base call, file call

    global control;
    handles = fpgGetHandles();
    k = control.fpg.k;
    if nargout == 1
        return;
    end
    bcStr = get(handles.ddBaseChannel, 'String');
    bcVal = get(handles.ddBaseChannel, 'Value');
    baseChannel = str2double(bcStr(bcVal));
    v = get(handles.ddBaseCall, 'Value');
    S = get(handles.ddBaseCall, 'String');
    baseCall = str2double(S(v));
    cellSelection = get(handles.uitabFileCalls, 'UserData');
    if isempty(cellSelection)
        if ~isempty(control.fpg.a)
            fileCall = control.fpg.a;
        else
            fileCall = 0;
        end
    else
        fileCall = cellSelection(1);
    end

end

