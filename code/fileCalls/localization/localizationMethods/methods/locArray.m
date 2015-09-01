function [ x,t ] = locArray( callsTimes, micArray, params )
%LOCARRAY Localization through array: Build array of positions and compute 
%time diffs between all channels if a bat was calling at each position. 
%Compare to measured diff to approximate bat location

% for better performance, the array construiction and the use can be
% seperated to different times - constructing only once at mic admin, and
% using multiple times on localization.

    xlim = [params.xliml, params.xlimh];
    ylim = [params.yliml, params.ylimh];
    zlim = [params.zliml, params.zlimh];
    dTm = callsTimes - callsTimes(1);
    
    [dTX,X] = computeMicsTimeDiff( micArray, params.xres, xlim, params.yres, ylim, params.zres, zlim, params.sonic );
    usedMics = 1:size(micArray,1);
    x = locateBatPrecomputedArray( dTX,X,dTm, usedMics ); 
    t = callsTimes(1);

end

function x = locateBatPrecomputedArray( dTX,X,dTm, usedMics )
%LOCATEBATPRECOMPUTEDARRAY Locate the bat using a precomputed array of
%positions

    % assuming both dTX and dTm noramzlized to 0 at first coordinate
    dTX = dTX(usedMics,:);
    dTm = dTm(usedMics);

    % compare
    F = repmat(dTm,1,size(dTX,2));
    A = sum(abs(dTX - F));
    [~, minArg] = min(A);
    
    x = X(minArg,:);
end