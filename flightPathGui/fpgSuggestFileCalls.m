function seqs = fpgSuggestFileCalls(  )
%FPGSUGGESTFILECALLS Summary of this function goes here
%   Detailed explanation goes here

    [k,j,s] = fpgGetCurrent();
    timePointToUse = 'Start';
    
    seqs = suggestSeqs( s,j,k, timePointToUse);

end

