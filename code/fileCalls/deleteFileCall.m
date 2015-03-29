function [  ] = deleteFileCall( k, A )
%DELETEFILECALL Remove file call from file object

    global filesObject;
    
    % check not empty
    if isempty(A)
        return;
    end
    
    % check range
    N = fileData(k, 'Calls', 'Count');
    if N < max(A)
        err = MException('bats:fileCalls:outOfRange','File calls out of range');
        throw(err);
    end
    
    % delete
    filesObject(k).fileCalls(A)=[];
    
end

