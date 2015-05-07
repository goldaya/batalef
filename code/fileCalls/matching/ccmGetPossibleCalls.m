function [ I, W ] = ccmGetPossibleCalls( k,V,u,dev )
%CCMGETPOSSIBLECALLS -INTERNAL- get possible calls in channel u possible
%for channel calls in vector V

    % get times of all channelcalls in channel u
    [W,I] = channelData(k,u,'Calls','ForLocalization','Times','Peak');
    W = cell2mat(W);
    
    % remove "taken" calls
    F = zeros(length(W),1);
    for i = 1:length(W)
        call = channelCall(k,u,I(i),'forLocalization',false);
        F(i) = call.FileCall;
    end
    W = W(F==0);
    I = I(F==0);
    
    % get calls to check against
    J = find(V);
    if isempty(J)
        %I = [I,0];
        return;
    end
    % get maximal diff between channels
    M = fileData(k,'Mics','MaxDiff');
    
    % check
    for i = 1:length(J)
        j = J(i);
        
        % get possible window around 
        call = channelCall(k,j,V(j),'forLocalization',false);
        window = M(j,u)*dev*[-0.5,0.5] + call.PeakTime;
        I = I(W>=window(1));
        W = W(W>=window(1));
        I = I(W<=window(2));
        W = W(W<=window(2));
        if isempty(W)
            break;
        end
    end
    
    %I = [I,0];
end

