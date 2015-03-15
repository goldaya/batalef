function [ env, T ] = getEnvelope( k, j, samplesInterval, filter2use )
%GETENVELOPE Summary of this function goes here
%   Detailed explanation goes here

    [ dataset,T ] = channelData(k,j,'TimeSeries', samplesInterval, 'Filter', filter2use);
    Fs = channelData(k,j,'Fs');
    [ env ]       = computeEnvelope(dataset,Fs);

    % resize Time coordinates vector to be the same as env.
    de = length(T)-length(env);
    s1 = max(floor(de/2),1);
    s2 = min(ceil(de/2)+length(env),length(env));
    T = T(s1:s2);

end

