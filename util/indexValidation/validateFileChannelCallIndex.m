function [ validated ] = validateFileChannelCallIndex( k,j,s,noException )
%VALIDATEFILECHANNELCALLINDEX

    if ~exist('noException', 'var')
        noException = false;
    end
    
    % file, channel
    validated = validateFileChannelIndex(k,j,noException);
    if ~validated
        return;
    end

    n = channelData(k,j,'Calls','Count');
    if n < s
        validated = false;
        if ~noException
            err = MException('bats:channelCalls:indexOutOfRange','The channel call %d is out of range for file index %d, channel %d', s, k, j);
            throw( err );
        end
    else
        validated = true;
    end
    
end

