function [ x ] = locDiscreteArray( dT,micArray,sonicSpeed,params,~ )
%LOCDISCRETEARRAY Build array of positions and compute time diffs between
%all channels if a bat was calling at each position. Compare to measured
%diff to approximate bat location

    [dTX,X] = computeMicsTimeDiff( micArray, params.xRes, params.xLim, params.yRes, params.yLim, params.zRes, params.zLim, sonicSpeed );

    % compare
    F = repmat(dT,1,size(dTX,2));
    A = sum(abs(dTX - F));
    [~, minArg] = min(A);
    x = X(minArg,:);   

end

function [ndTX,X] = computeMicsTimeDiff( micArray, xRes, xLim, yRes, yLim, zRes, zLim, sonicSpeed )
%COMPUTEMICSTIMEDIFF Compute the time differences between channels at each
%point in a given box (around [0,0,0]);

    x = linspace(xLim(1),xLim(2),floor(diff(xLim)/xRes)+1);
    y = linspace(yLim(1),yLim(2),floor(diff(yLim)/yRes)+1);
    z = linspace(zLim(1),zLim(2),floor(diff(zLim)/zRes)+1);
    [A,B,C] = ndgrid(x,y,z);
    X = [A(:),B(:),C(:)];
    
    if size(micArray,2) ~= 3
        M = micArray';
    else
        M = micArray;
    end
    
    dTX = pdist2(M,X)./sonicSpeed;
    
    ndTX = dTX - repmat(dTX(1,:),size(M,1),1);

end
