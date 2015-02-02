function [ R ] = suggestSeqs( s,j,k, timePointToUse )
%SUGGESTSEQS Summary of this function goes here
%   Detailed explanation goes here
  
    R = suggestSeqs2(s,j,k,timePointToUse);
    return;
    
    refPoint = channelCallData(k,j,s,timePointToUse,'Point');
        
    [~,MdP] = fileData(k,'Mics','MaxDiff');
    
    %nChannels = fileData(k,'nChannels');
    nMicsTotal = fileData(k,'Mics','Count','NoValidation',true);
    J = 1:nMicsTotal;
    J = J(fileData(k,'Mics','LocalizationUsage','NoValidation',true));
    nMicsUsed = length(J);
    
    seq = zeros(nMicsTotal, 1);
    seq(j) = s;
    R{1} = seq;
       
    dev = getParam('fileCalls:matching:triangleMaxError');
    for i = 1:nMicsUsed
        if J(i)==j
            continue
        end
        
        % calculate the interval to look for calls in channel {i} that
        % might relate to the ref-call
        dp = MdP(J(i),j)*dev;
        a = refPoint - dp;
        b = refPoint + dp;
        [~,V] = determinePossibleCalls(k,J(i),a,b,timePointToUse,'noFileCalls',true);
        if isempty(V)
            R = [];
            return;
        end
        %V = [0,V]; % add the 'dont use this channel' index
        
        
        % now compute for all possible sequences
        Rtmp = cell(length(R)*length(V),1);
        index = 1;
        for l=1:length(R)   % loop at possible sequences for channels {1,2,...,i-1}
            for t=1:length(V)   % loop at possible calls in channel i
                seq = R{l};
                seq(J(i)) = V(t);
                if seqIsPossible(k,seq,timePointToUse)
                %{
                    % must have at least 4 channel calls
                    if nChannels - i < nChannels - 8
                        tmp = seq(seq>0);
                        if length(tmp) < 8
                            addSeq = false;
                        else
                            addSeq = true;
                        end
                    else
                        addSeq = true;                        
                    end
                    %}
                    addSeq = true;
                else
                    addSeq = false;
                end
                
                if addSeq
                    Rtmp{index} = seq;
                    index = index + 1;
                else
                    Rtmp(index) = []; % remove the cell
                end
                
            end
        end

        R = Rtmp;
    end
       

end

