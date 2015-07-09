function [  ] = pdPiecewise( k,I,percentile,fixedThreshold,minDistance,channel,filter,replace )
%PDPIECEWISE Summary of this function goes here
%   Detailed explanation goes here

    Fs = fileData(k,'Fs');
    
    % determine channels
    if ischar(channel) % then must be 'All'
        J = 1:fileData(k,'Channels','Count');
    else
        J = channel;
    end

    % do
    
    for l = 1:length(J)
        j = J(l);
        if validateFileChannelIndex(k,j)
            % clear all in advance when replacing
            if replace
                channelCall.removeCalls(k,j,[]);
            end
            
            for i = 1:size(I,1)
                dataset = channelData(k,j,'Envelope','Interval',I(i,:),'Filter',filter);
                threshold = max(prctile(dataset,percentile),fixedThreshold);
                peaks = pdBasicCore(dataset, Fs, threshold, minDistance,0);
                peaks.points = peaks.points + I(i,1) - 1;
                peaks.times = peaks.points ./ Fs;
                channelCall.addCalls(k,j,[peaks.times,peaks.values]);
            end
        end
    end
    
    
    
end

