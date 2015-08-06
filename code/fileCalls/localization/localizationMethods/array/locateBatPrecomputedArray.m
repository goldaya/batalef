function x = locateBatPrecomputedArray( dTX,X,dTm, usedMics )
%LOCATEBATPRECOMPUTEDARRAY Locate the bat using a precomputed array of
%positions

    % assuming both dTX and dTm noramzlized to 0 at first coordinate
    dTX = dTX(usedMics,:);
    dTm = dTm(usedMics);

    % compare
    F = repmat(dTm,1,size(dTX,2));
    A = sum(abs(dTX - F));
    [minVal, minArg] = min(A);
    
    x = X(minArg,:);
end

