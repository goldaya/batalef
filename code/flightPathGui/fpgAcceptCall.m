function [  ] = fpgAcceptCall(  )
%FPGACCEPTCALL Summary of this function goes here
%   Detailed explanation goes here
    
    handles = fpgGetHandles();
    k = fpgGetCurrent();
    
    Seqs = get(handles.ddSeqs, 'UserData');
    if isempty(Seqs)
        msgbox('No call');
        return;
    end
    v = get(handles.ddSeqs, 'Value');
    
    a = addFileCall(k, Seqs{v});
    fpgRefresh(a);
    
end

