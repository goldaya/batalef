function [x] = test1(mics,sonic,lim,res,ndTm)

%    dim = floor(diff(lim)/res) + 1;
    % create matrix of distances from each mic
    S = lim(1):res:lim(2);
    [A,B,C] = ndgrid(S,S,S);
    X = [A(:),B(:),C(:)];
    dTx = pdist2(mics,X)./sonic;
 
    % normalize such that the first coordinate is zero
    ndTx = dTx - repmat(dTx(1,:),12,1);
    
    % find minimal difference
    F = repmat(ndTm,1,size(dTx,2));
    [minVal,minArg] = min(sqrt(sum((ndTx - F).^2,1)));
    
    % recover coordiantes
    x = X(minArg,:);
    
end