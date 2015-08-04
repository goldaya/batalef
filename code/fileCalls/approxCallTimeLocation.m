function [ t, x ] = approxCallTimeLocation( channelCallsTimes, MicPositions )
%APPROXCALLTIMELOCATION Approximate the time and location (3D) of the file
%call
%   Detailed explanation goes here

    % downscale to actual calls
    relevantCalls = channelCallsTimes > 0;
    times = channelCallsTimes(relevantCalls);
    mPoss = MicPositions(relevantCalls,:);
    
    % build time intervals array
    intArray = times - times(1);

    % approximate 3D location
    sonic = getParam('soundSpeed');
    %disp('MLAT');
    %x = MLAT( mPoss, intArray, sonic )
    
    %disp('Array');
    res = 0.1;
    lim = [-3,3];
    dTm = times - times(1);
    x = locateBatThroughArray( mPoss, res, lim, res, lim, res, lim, sonic, dTm );
    
    % time
    t = times(1);

end