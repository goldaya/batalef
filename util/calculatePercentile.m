function thPercentile = calculatePercentile( thValue, rdata )
%CALCULATETHPERCENTILE Calculate the percentile using the value
%   Detailed explanation goes here

    sdata = sort(rdata);
    
    % use bisection method!
    p = 0;
    c = 3; % just for initialization
    i = 1;
    
    while c > 1   % do while there are np more than 2 samples
        a = 1;
        b = length(sdata);        
        c = floor((b-a+1)/2);
        
        if sdata(c) < thValue
            a = c;
            p = p + 2.^(-i);
        elseif sdata(c)  > thValue
            b = c;
        else
            p = p + 2.^(-i);
            break;
        end
        % shrink dataset
        sdata = sdata(a:b);
        % inc step
        i = i + 1;
    end

    % output percent
    thPercentile = (round(p.*10000))/100;
end

