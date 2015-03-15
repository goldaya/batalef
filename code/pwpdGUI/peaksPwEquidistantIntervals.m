function [ I ] = peaksPwEquidistantIntervals( nsamples, fs, window, overlap )
%PEAKSPWEQUIDISTANTINTERVALS Build equidistant intervals for piece-wise peak detection
%   nsamples = number of samples in raw data
%   fs = sampling frequency
%   windows = length of windows in miliseconds
%   overlap = overlap of windows (miliseconds)

    % get technical values (in sample points)
    techWindowLength = floor(window*fs/1000);
    if techWindowLength==0
        err = MException('peaksPieceWise:WrongIntevals', 'Window is of zero length');
        throw(err);
    end
    techOverlap = floor(overlap*fs/1000);
    d = techWindowLength - techOverlap;
    
    % calculate number of intervals, make sure last interval is not too
    % short
    L = floor(nsamples/d);
    if (L-1)*d+techWindowLength >= nsamples
        L = L-1;
    end
    
    % build intervals
    I = zeros(L+1, 2);
    for i = 1:(L+1)
        
        if i==1
            a = 1;
        else
            a = (i-1)*d;
        end
        
        if i==L+1
            b = nsamples;
        else
            b = a + techWindowLength;
        end
        
        I(i,:) = [a b];
    end
    

end

