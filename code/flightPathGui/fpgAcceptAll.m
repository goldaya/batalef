function fpgAcceptAll(  )
%FPGACCEPTALL Internal Accept all possible file calls

    timePointToUse = 'Start';
    
    % get current base
    [k,~,j,~] = fpgGetCurrent;
    
    % go over unassigned base calls
    n = channelData(k,j,'Calls','Count');
    for s = 1:n
        if channelCallData(k,j,s,'FileCall')==0
            % get possible seq
            seqs = suggestSeqs( s,j,k, timePointToUse );
            if ~isempty(seqs)
                % accept 1st seq.
                addFileCall(k, seqs{1});
            end
        end
    end
    
end

