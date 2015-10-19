function [ out ] = getInterval( dataset, Fs, interval )
%GETINTERVAL get a subset of the dataset based on time interval

    np = length(dataset);
    I = round(interval.*Fs);
    if I(1) < 1
        I(1) = 1;
    elseif I(1) > np
        I(1) = np;
    end
    if I(2) < 1
        I(2) = 1;
    elseif I(2) > np
        I(2) = np;
    end        

    out = dataset(I(1):I(2));
    
end

