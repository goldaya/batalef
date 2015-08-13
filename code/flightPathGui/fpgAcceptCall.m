function [  ] = fpgAcceptCall(  )
%FPGACCEPTCALL Accept a sequence, approximate time & location and provide
%the powers matrix for beam computation

    
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