function [  ] = pdPiecewise( k,I,percentile,minDistance,channel,filter,replace )
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
                removeChannelCalls(k,j,'All')
            end
            
            for i = 1:size(I,1)
                dataset = channelData(k,j,'Envelope','Interval',I(i,:),'Filter',filter);
                threshold = prctile(dataset,percentile);
                peaks = pdBasicCore(dataset, Fs, threshold, minDistance,0);
                peaks.points = peaks.points + I(i,1) - 1;
                addChannelCalls(k,j,[peaks.points,peaks.values],false,true);
            end
        end
    end
    
    msgbox('Finished calls detection');
    
end

