function [ L ] = determineLogicalMatrix( S1,S2, m )
%DETERMINELOGICALMATRIX For 2 sets of possible channel calls from 2
%different channels, create a logical matrix saying which combination is
%possible
%   Si = channel call times
%   m  = time diff between the two mics
%   L  = the logical matrix

    n1 = length(S1);
    n2 = length(S2);
    
    v1 = ones(1,n2);
    D1 = S1 * v1;

    v2 = ones(n1,1);
    D2 = v2 * transpose(S2);
    
    D = m - abs(D1 - D2);
    
    % add the 'without 1st channel' all ones vector
    %V = ones(1,n2);
    %D = [D;V];
    
    L = D > 0;
    
end

