function [  ] = fpgNextBaseCall(  )
%FPGNEXTBASECALL Summary of this function goes here
%   Detailed explanation goes here

    handles = fpgGetHandles();
    v = get(handles.ddBaseCall, 'Value' ) + 1;  
    S = get(handles.ddBaseCall, 'String' );
    if v > max(size(S))
        msgbox('Last base call for base channel')
    else
        fpgRefreshBaseCallsList();
        set(handles.ddBaseCall, 'Value', v);
        fpgRefreshSeqList();
    end

end

