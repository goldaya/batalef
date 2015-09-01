function [ k,a,j,s,A ] = fcgGetCurrent(  )
%FCGGETCURRENT Returns a vector of the current file, call, base channel and
%base call indexes (note that the call is a single value and is the one on
%display)

    global control;
    k = control.fcg.k;
    if nargout == 1
        return;
    end
    
    handles = getHandles('fcg');
    A = str2num(get(handles.textIdx,'String')); %#ok<ST2NM>
    if isempty(A)
        a = 0;
    else
        a = A(1);
    end
    if nargout == 2
        return;
    end
    
    v = get(handles.ddBaseChannel,'Value');
    S = get(handles.ddBaseChannel,'String');
    j = str2double(S(v));
    if nargout == 3
        return;
    end
    
    v = get(handles.ddBaseCall,'Value');
    S = get(handles.ddBaseCall,'String');
    s = str2double(S(v));    
    if nargout == 4
        return;
    end
    
    A = str2num(get(handles.textIdx,'String')); %#ok<ST2NM>

end

