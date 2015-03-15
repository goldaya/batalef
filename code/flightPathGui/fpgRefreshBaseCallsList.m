function [  ] = fpgRefreshBaseCallsList( s )
%FPGREFRESHBASECALLSLIST Refresh the base call list according to selected
%base channel
%   Shows only available (not file calls) channel calls

    handles = fpgGetHandles();
    
    if ~exist('s','var')||isempty(s)||s==0
        s = 1;
    end
    
    [k,j] = fpgGetCurrent();
    n = channelData(k,j,'Calls','Count');
    l = 0;          % dropdown list indexes
    S = cell(0,1);  % dropdown list strings
    v = 1;          % next base call index
    for i = 1:n
        if channelCallData(k,j,i,'FileCall')==0
            l = l +1;
            S{l} = i;
            if i == s
                v = l;
            end
        end
    end
    
    if isempty(S)
        S = 'N/A';
    end
    
    set(handles.ddBaseCall, 'String', S);
    set(handles.ddBaseCall, 'Value', v);

end

