function [ newTS ] = createSecondaryTS( k,buffer )
%CREATESECONDARYTS -INTERNAL- flattens the channel calls in a TS.

    % get full TS
    N  = fileData(k,'Channels','Count');
    Fs = fileData(k,'Fs');
    nS = fileData(k,'nSamples');
    newTS = zeros(nS,N);
    
    % create new TS
    for j = 1:N
        TS = channelData(k,j,'TS');
        starts = round((cell2mat(channelData(k,j,'Calls','features','Times','Start'))-buffer).*Fs);
        starts(starts < 1 ) = 1;
        ends   = round((cell2mat(channelData(k,j,'Calls','features','Times','End'  ))+buffer).*Fs);
        ends( ends > nS ) = nS;
        for i = 1:length(starts)
            TS(starts(i):ends(i)) = zeros(ends(i)-starts(i)+1,1);
        end
        newTS(:,j) = TS;
    end

end

