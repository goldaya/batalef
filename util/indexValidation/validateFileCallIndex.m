function [ validated ] = validateFileCallIndex( k, a )
%VALIDATEFILECALLINDEX 

    if ~exist('noException', 'var')
        noException = false;
    end
    
    % file validation
    validated = validateFileIndex(k,noException);
    if ~validated
        return;
    end
    
    n = fileData(k, 'Calls', 'Count');
    if n < a
        validated = false;
        if exist('noException', 'var') && noException
        else
            err = MException('bats:fileCall:indexOutOfRange','The file call index %d is out of range for file %d', {k,a});
            throw( err );
        end
    else
        validated = true;
    end

end

