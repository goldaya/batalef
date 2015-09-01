function [ t, x ] = approxCallTimeLocation( channelCallsTimes, MicPositions )
%APPROXCALLTIMELOCATION Approximate the time and location (3D) of the file
%call

    % downscale to actual calls
    relevantCalls = channelCallsTimes > 0;
    times = channelCallsTimes(relevantCalls);
    mPoss = MicPositions(relevantCalls,:);
    
    [x,t] = locAdminCompute(times,mPoss);
    
end