function [ M ] = maxTimeDiffBetweenChannels( P )
%MAXTIMEDIFFBETWEENCHANNELS Build a matrix of the maximal time difference
%of a call between channels
%   Detailed explanation goes here

    soundSpeed = getParam('soundSpeed');
    N = size(P, 1);
    
    M = zeros(N);
    for i = 1:N
        for j = i+1:N
            dx = P(i,1)-P(j,1);
            dy = P(i,2)-P(j,2);
            dz = P(i,3)-P(j,3);
            d = sqrt(dx^2+dy^2+dz^2);
            dt = d/soundSpeed;
            M(i,j) = dt;
            M(j,i) = dt;
        end
    end
    

end

