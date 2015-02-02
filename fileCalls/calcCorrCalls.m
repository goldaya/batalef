function [ c ] = calcCorrCalls( k, j1, s1, j2, s2 )
%CALCCORRCALLS Calculate the correlation between calls
%   Detailed explanation goes here

    call1 = channelCallData(k,j1,s1,'TS');
    call2 = channelCallData(k,j2,s2,'TS');
    if isempty(call1) || isempty(call2)
        c = 0;
    else
        c = max(xcorr(call1,call2,'coeff'));
    end
    
end

