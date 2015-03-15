function [ isPossible ] = seqIsPossible( k, seq, timePosition )
%SEQISPOSSIBLE Determine if a sequence is possible

   
    % seq with 3 or less elements is always possible
    tmp = seq(seq>0);
    if length(tmp) < 4
        isPossible = 1;
        return;
    end
    
    % get the times vector
    nChannels = fileData(k,'Channels','Count');
    v = zeros(nChannels,1);
    for i = 1:nChannels
        if seq(i)==0
            v(i) = 0;
        else
            %{
            [times] = getChannelCallsTimes(k,i,timePosition);
            v(i) = times(seq(i));
            %}
            v(i) = channelCallData(k,i,seq(i),timePosition,'Point');
        end
    end
    
    % get time diff from mic positions
    [~,M] = fileData(k, 'Mics','MaxDiff');
    M = M.*1.05;
    
    % check that time diff between calls are not more than possible
    for i = 1:nChannels
        for j = i+1:nChannels
            if v(j)~=0 && v(i)~=0
                dt = abs(v(i) - v(j));
                if dt > M(i,j)
                    isPossible = 0;
                    return;
                end
            end
        end
    end
    
    % everything OK
    isPossible = 1;
end

