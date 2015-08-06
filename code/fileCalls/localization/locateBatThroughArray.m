function [ x ] = locateBatThroughArray( micArray, xRes, xLim, yRes, yLim, zRes, zLim, sonicSpeed, dTm )
%LOCATEBATTHROUGHARRAY Build array of positions and compute time diffs
%between all channels if a bat was calling at each position. Compare to
%measured diff to approximate bat location

    [dTX,X] = computeMicsTimeDiff( micArray, xRes, xLim, yRes, yLim, zRes, zLim, sonicSpeed );
    usedMics = 1:size(micArray,1);
    x = locateBatPrecomputedArray( dTX,X,dTm, usedMics );

end

