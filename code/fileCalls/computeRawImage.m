function [ M ] = computeRawImage(azCoors, elCoors, AZ, EL, P)
%COMPUTERAWIMAGE Summary of this function goes here
%   Detailed explanation goes here

    M = NaN(length(elCoors),length(azCoors));
    for i = 1:length(P)
        % get the most appropiate cell
        A = abs(azCoors - AZ(i));
        [~,iAZ] = min(A);
        A = abs(azCoors - EL(i));
        [~,iEL] = min(A);
        M(iEL,iAZ) = P(i);
    end

end

