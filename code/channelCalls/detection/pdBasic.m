function [ cancel ] = pdBasic( K, dialog )
%PDBASIC Detect calls using peak detection

    cancel = true;
    if isempty(K)
        return;
    end
    
    if ~exist('dialog','var')
        dialog = true;
    end
    
    [do, percentile, minDistance, replace, channel, filter, fixedThreshold] = pdBasicAsk(dialog);
    if ~do
        return;
    end
    
    cancel = false;
    
    % do for all specified files
    for i=1:length(K)
        k = K(i);
        
        % determine channels
        if ischar(channel) || channel == 0 % then must be 'All'
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
                threshold = max(prctile(dataset,percentile),fixedThreshold);
                peaks = pdBasicCore(dataset, Fs, threshold, minDistance,0);
                addChannelCalls(k,j,[peaks.times,peaks.values],replace);
            end
        end
    end
    


end

