function [ validated ] = validateFileIndex( k, noException )
%VALIDATEFILEINDEX 

    global filesObject;
    
    if length(filesObject) < k
        validated = false;
        if exist('noException', 'var') && noException
        else
            err = MException('bats:files:indexOutOfRange','The file index %d is out of range of file list', k);
            throw( err );
        end
    else
        validated = true;
    end
    
end

