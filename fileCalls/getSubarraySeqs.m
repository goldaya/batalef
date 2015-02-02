function [ seqs ] = getSubarraySeqs( subarray, channelCalls )
%GETSUBARRAYSEQS INTERNAL RECURSIVE

    cc = channelCalls{1};
    if subarray(1) == 0
        cc = 0;
    elseif isempty(cc)
        seqs = [];
        return;
    end
    
    
    n = length(subarray);
    if n == 1
        R = cc;
        if size(R,1)==1 && size(R,2) > 1
            seqs = transpose(R);
        else
            seqs = R;
        end
        return;
    else
        R = getSubarraySeqs(subarray(2:n),channelCalls(2:n,:));
    end
    
    % R is empty only on error. propogate error.
    if isempty(R)
        seqs = [];
        return;
    end
    
    % add this thred calls to matrix
    nR = size(R,1);
    nC = length(cc);
    
    seqs = zeros(nR*nC,n);
    for i=nC
        % seqs row coordinates
        iStart = (i-1)*nR + 1;
        iEnd = i*nR;
        
        v = ones(nR,1) .* cc(i);
        seqs(iStart:iEnd,:) = [v,R];
    end
    
end

