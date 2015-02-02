function [ sSeq, sCorr, R, C, idx ] = suggestSeqs( s,j,k, threshold, paramToUse )
%SUGGESTSEQS Summary of this function goes here
%   Detailed explanation goes here
  
    sSeq = [];
    sCorr = 0;
    R = [];
    C = [];
    idx = 0;
      
    refPoint = channelCallData(k,j,s,paramToUse,'Point');
        
    [~,MdP] = fileData(k,'Mics','MaxDiff');
    C = ones(1);
    
    nChannels = fileData(k,'nChannels');
    seq = zeros(nChannels, 1);
    seq(j) = s;
    R{1} = seq;
       
    dev = 1.05;
    for i = 1:nChannels
        if i==j
            continue
        end
        
        % calculate the interval to look for calls in channel {i} that
        % might relate to the ref-call
        dp = MdP(i,j)*dev;
        a = refPoint - dp;
        b = refPoint + dp;
        [~,V] = determinePossibleCalls(k,i,a,b,paramToUse,'noFileCalls');
        if isempty(V)
            % discard ref call when no possible sequence
            return;
        end
        
        % calculate cross correlation with ref call
        if length(V)==1
            X=ones(1,1);
        else
            X = zeros(length(V), 1);
            for t =1:length(V)
                X(t) = calcCorrCalls(k,j,s,i,V(t));
            end
        end
        
        % now compute for all possible sequences
        C1 = zeros(length(C)*length(V),1);
        R1 = cell(size(C1));
        for l=1:length(R)   % loop at possible sequences for channels {1,2,...,i-1}
            for t=1:length(V)   % loop at possible calls in channel i
                index = (l-1)*length(V)+t;
                seq = R{l};
                seq(i) = V(t);
                R1{index} = seq;
                if seqIsPossible(k,seq,paramToUse)
                    C1(index) = X(t)*C(l);
                else
                    C1(index) = 0;
                end
            end
        end
        % discard ref call when no possible sequence
        if max(C1)==0
           return; 
        end
        % normalise by making max = 1
        C1 = C1(C1 > threshold);
        C = C1./max(C1);
        R = R1(C1 > threshold);
    end
    
    %{
    % fix the sequences: put ref call in its right place, then check if
    % sequence is really possible
    for i = 1:length(R)
       seq = R{i};
       seq = seq(2:length(seq));
       seq(j+1:end+1) = seq(j:end);
       seq(j) = s;
       R{i} = seq;
       if ~seqIsPossible(k,seq)
           C(i) = 0;    % zero-valued seq will never be picked up
       end
    end
    %}
    
    % exit without giving anything
    if max(C)==0
        return;
    end
    
    % now, all sequances in R are possible, suggest the one with highest
    % overall cross correlation (in vector C)
    [~,idx] = max(C, [], 1);
    sSeq = R{idx};
    sCorr = C(idx);

end

