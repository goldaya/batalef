function [  ] = fcgNextBaseCall(  )
%FCGNEXTBASECALL Go to next base call

    handles = getHandles('fcg');
    v = get(handles.ddBaseCall, 'Value' ) + 1;  
    S = get(handles.ddBaseCall, 'String' );
    if strcmp(S,'N/A')
        msgbox('No Call');
        return;
    elseif v > max(size(S))
        msgbox('Last base call for base channel')
    else
        set(handles.ddBaseCall, 'Value', v);
        fcgPopulatePossibleMatches();
    end

end

