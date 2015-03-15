function [  ] = fpgRefreshSeqList(  )
%FPGREFRESHSEQLIST Summary of this function goes here
%   Detailed explanation goes here

    handles = fpgGetHandles();
    set(handles.ddSeqs, 'Value', 1);
    Seqs = fpgSuggestFileCalls();
    if isempty(Seqs)
        S = 'N/A';
    else
        %S{1}='';
        n=length(Seqs);
        S = cell(n,1);
        for i=1:n
            A = seq2string(Seqs{i});
            S{i}=A;
        end
    end

    set(handles.ddSeqs, 'String', S);
    set(handles.ddSeqs, 'UserData', Seqs);
    
end

