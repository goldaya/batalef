function seqs = fpgSuggestFileCalls(  )
%FPGSUGGESTFILECALLS Summary of this function goes here
%   Detailed explanation goes here

    seqs = [];
    [k,~,j,s] = fpgGetCurrent();
    if isnan(s)
        return;
    end
    timePointToUse = 'Start';
    if isscalar(s)
        seqs = suggestSeqs( s,j,k, timePointToUse);
    end

end

