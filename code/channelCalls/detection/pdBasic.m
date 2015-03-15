function [  ] = pdBasic( K )
%PDBASIC Detect calls using peak detection

    if isempty(K)
        return;
    end
    
    [do, percentile, minDistance, replace, channel, filter] = pdBasicAsk();
    if ~do
        return;
    end
    
    % do for all specified files
    for i=1:length(K)
        k = K(i);
        
        % determine channels
        if ischar(channel) % then must be 'All'
            J = 1:fileData(k,'Channels','Count');
        else
            J = channel;
        end

        % do
        for l = 1:length(J)
            j = J(l);
            if validateFileChannelIndex(k,j,true)
                Fs = channelData(k,j,'Fs');
                dataset = channelData(k,j,'Envelope','Filter',filter);
                threshold = prctile(dataset,percentile);
                peaks = pdBasicCore(dataset, Fs, threshold, minDistance,0);
                addChannelCalls(k,j,[peaks.points,peaks.values],replace,true);
            end
        end
    end
    


end

