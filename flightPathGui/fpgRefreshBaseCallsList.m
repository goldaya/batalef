function [  ] = fpgRefreshBaseCallsList( )
%FPGREFRESHBASECALLSLIST Refresh the base call list according to selected
%base channel
%   Shows only available (not file calls) channel calls

    handles = fpgGetHandles();
    set(handles.ddBaseCall, 'Value', 1);
    [k,j] = fpgGetCurrent();
    n = channelData(k,j,'Calls','Count');
    l = 0;
    S{1}='';
    for i = 1:n
        if channelCallData(k,j,i,'FileCall')==0
            l = l +1;
            S{l} = i;
        end
    end

    set(handles.ddBaseCall, 'String', S);

end

