function [ newTS ] = createSecondaryTS( k )
%CREATESECONDARYTS -INTERNAL- flattens the channel calls in a TS.

    % get full TS
    N  = fileData(k,'Channels','Count');
    %TS = fileData(k,'TS');
    Fs = fileData(k,'Fs');
    
    newTS = zeros(fileData(k,'nSamples'),N);
    
    
    for j = 1:N
        TS = channelData(k,j,'TS');
        starts = round(cell2mat(channelData(k,j,'Calls','ForLocalization','Times','Start')).*Fs);
        ends   = round(cell2mat(channelData(k,j,'Calls','ForLocalization','Times','End'  )).*Fs);
        for i = 1:length(starts)
            TS(starts(i):ends(i)) = zeros(ends(i)-starts(i)+1,1);
        end
        newTS(:,j) = TS;
    end

end

