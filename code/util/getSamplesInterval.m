function [ samplesInterval ] = getSamplesInterval( k, thing )
%GETSAMPLESINTERVAL Retrieve samples interval from varargin or [1,last
%point in file]

    nSamples = fileData(k,'nSamples');
    
    
    timeInterval = getParFromVarargin('TimeInterval',thing);
    if ~timeInterval
        samplesInterval = getParFromVarargin('Interval',thing);
    else
        samplesInterval = round(timeInterval.*fileData(k,'Fs','NoValidation',true));
    end
    
    if ~isempty(samplesInterval) && size(samplesInterval,1)==1 && size(samplesInterval,2)==2
    elseif ~isempty(thing) && size(thing{1},1)==1 && size(thing{1},2)==2
        samplesInterval = thing{1};
    else
        samplesInterval = [1, nSamples];
    end
    
    % regulate boundries
    if samplesInterval(1) < 1
        samplesInterval(1) = 1;
    end
    if samplesInterval(2) > nSamples
        samplesInterval(2) = nSamples;
    end
    


end

