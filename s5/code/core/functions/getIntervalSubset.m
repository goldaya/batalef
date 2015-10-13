function [ S,I ] = getIntervalSubset( D,idx,interval,useCell)
%GETINTERVALSUBSET Get a subset of the data, according to a given interval
%on a specific column index

    I = 1:size(D,1);
    if isempty(interval) || isempty(D)
        S = D;
    else
        if useCell
            I1 = [D{:,idx}] >= interval(1);
            I2 = [D{:,idx}] <= interval(2);
        else
            I1 = D(:,idx) >= interval(1);
            I2 = D(:,idx) <= interval(2);
        end
        S = D(logical(I1.*I2),:);
        I = I(logical(I1.*I2));
    end      
    
end

