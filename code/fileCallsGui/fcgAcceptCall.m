function [  ] = fcgAcceptCall(  )
%FCGACCEPTCALL Accept a sequence, approximate time & location and provide
%the powers matrix for beam computation

    
    handles = getHandles('fcg');
    k = fcgGetCurrent();
    
    Seqs = get(handles.ddSeqs, 'UserData');
    if isempty(Seqs)
        msgbox('No call');
        return;
    end
    v = get(handles.ddSeqs, 'Value');
    
    a = addFileCall(k, Seqs{v});
    fcgRefresh( a );
    
end