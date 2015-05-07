function [ seqs ] = ccmSimple( k,j,s,dev )
%CCMSIMPLE -INTERNAL- match comparing only the base channel

    baseCall = channelCall(k,j,s,'forLocalization',false);
    baseCall.PeakTime;
    
    M = fileData(k,'Mics','MaxDiff');
    
    U = fileData(k,'Mics','LocalizationUsage');
    U(j) = false;
    J = find(U);
    
    for i = 1 : length(J)
        window = M(j,J(i))*dev*[-0.5,0.5] + baseCall.PeakTime;
    
        % get times of all channelcalls in channel J(i)
        [W,I] = channelData(k,J(i),'Calls','ForLocalization','Times','Peak');
        W = cell2mat(W);
    
        % remove "taken" calls
        F = zeros(length(W),1);
        for i = 1:length(W)
            call = channelCall(k,u,I(i),'forLocalization',false);
            F(i) = call.FileCall;
        end
        W = W(F==0);
        I = I(F==0);
        
        % filter out of range
        I = I(W>=window(1));
        W = W(W>=window(1));
        I = I(W<=window(2));
        W = W(W<=window(2));
        
        % sort by closeness
        W = W - 
    end

end

