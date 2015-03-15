function [ t, x ] = approxCallTimeLocation( channelCallsTimes, MicPositions )
%APPROXCALLTIMELOCATION Approximate the time and location (3D) of the file
%call
%   Detailed explanation goes here

    % downscale to actual calls
    relevantCalls = channelCallsTimes > 0;
    times = channelCallsTimes(relevantCalls);
    mPoss = MicPositions(relevantCalls,:);
    
    % build time intervals array
    n = length(times);
    intArray = zeros(n,1);
    for j = 2:n
        intArray(j) = times(j) - times(1);
    end
    
    % get the speed of sound
    sonic = getParam('soundSpeed');
    
    % approximate 3D location
    x = MLAT( mPoss, intArray, sonic );
    
    % time
    t = times(1);

end