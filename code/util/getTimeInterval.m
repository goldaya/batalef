function [ timeInterval ] = getTimeInterval( k, thing )
%GETSAMPLESINTERVAL Retrieve time interval from varargin or [1,length]

    nSamples = fileData(k,'nSamples');
    Fs = fileData(k,'Fs');
    length = nSamples * Fs;
    
    timeInterval = getParFromVarargin('Interval',thing);
    
    if ~isempty(timeInterval) && size(timeInterval,1)==1 && size(timeInterval,2)==2
    elseif ~isempty(thing) && size(thing{1},1)==1 && size(thing{1},2)==2
        timeInterval = thing{1};
    else
        timeInterval = [1, length];
    end
    
    
    % regulate boundries
    if timeInterval(1) < 0
        timeInterval(1) = 0;
    end
    if timeInterval(2) > length
        timeInterval(2) = length;
    end
    


end

