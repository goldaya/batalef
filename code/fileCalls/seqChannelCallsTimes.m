function [ channelCallsTimes ] = seqChannelCallsTimes( k, seq )
%SEQCHANNELCALLSTIMES Summary of this function goes here
%   Detailed explanation goes here

    n = length(seq);
    channelCallsTimes = zeros(n,1);
    for j=1:n
        if seq(j)==0
            channelCallsTimes(j) = 0;
        else
            channelCallsTimes(j) = channelCallData(k,j,seq(j),'Start','Time','NoValidation',true);
        end
    end
    
end

