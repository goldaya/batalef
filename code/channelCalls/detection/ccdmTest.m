function [ CA ] = ccdmTest( dataset, Fs, params )
%CCDMTEST Summary of this function goes here
%   Detailed explanation goes here

    calls.points = [Fs];
    calls.values = [0];
    
    n = size(dataset,1);
    CA = cell(n,1);
    for i = 1:n
        CA{i} = calls;
    end

end

