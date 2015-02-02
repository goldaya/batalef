function [ validated ] = validateFileChannelIndex( k,j,noException )
%VALIDATEFILECHANNELINDEX 

    if ~exist('noException', 'var')
        noException = false;
    end
    
    % file index itself
    validated = validateFileIndex(k,noException);
    if ~validated
        return;
    end
    
    % channel within file
    n = fileData(k,'Channels','Count','NoValidation',true);
    if n < j
        validated = false;
        if ~noException
            err = MException('bats:channels:indexOutOfRange','The channel index %d is out of range for file index %d', j, k);
            throw( err );
        end
    else
        validated = true;
    end



end

