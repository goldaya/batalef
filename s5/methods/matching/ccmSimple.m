function [ seqs ] = ccmSimple( k,j,s,dev )
%CCMSIMPLE -INTERNAL- match comparing only the base channel

    baseCall = channelCall(k,j,s,'forLocalization',false);
    nChannels = fileData(k,'Channels','Count');
    M = fileData(k,'Mics','MaxDiff');
    U = fileData(k,'Mics','LocalizationUsage');
    U(j) = false;
    seqs = [];
    
    for i = 1 : nChannels
        
        if U(i)
            window = M(j,i)*dev*[-1,1] + baseCall.PeakTime;
    
            % get times of all channelcalls in channel J(i)
            [T,I] = channelData(k,i,'Calls','ForLocalization','Times','Peak');
            T = cell2mat(T);

            % filter out of range
            I = I(T>=window(1));
            T = T(T>=window(1));
            I = I(T<=window(2));
            T = T(T<=window(2));
            
            % remove "taken" calls
            F = zeros(length(I),1);
            for m = 1:length(I)
                call = channelCall(k,i,I(m),'forLocalization',false);
                F(m) = call.FileCall;
            end
            T = T(F==0);
            I = I(F==0);
            
            % sort by closeness
            if ~isempty(I)
                A = abs(T - baseCall.PeakTime);
                Q = [A I];
                Q = sortrows(Q);
                I = Q(:,2);
            end
            
            % add wildcard
            I = [I;0];
        elseif i == j
            I = s;
        else
            I = 0;
        end
        
        % expand sequences matrix
        nS = size(seqs,1);
        if nS == 0
            seqs = I;
        else
            seqsNext = [];
            for n = 1:length(I)
                S1 = [seqs ,ones(nS,1).*I(n)];
                seqsNext = [seqsNext;S1];
            end
            seqs = seqsNext;
        end
        
    end
    
    seqs = mat2cell(seqs,ones(size(seqs,1),1),nChannels);

end

