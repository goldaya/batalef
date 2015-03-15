function [ n ] = getFileIndex( fullpath )
%GETFILEINDEX Get file's index in the filesObject

    global filesObject;
    if isempty(filesObject)
        n = 0;
        return;
    end
    
    for k = 1:length(filesObject)
        if strcmp(fullpath,fileData(k,'Fullpath'))
            n = k;
            return;
        end
    end
    
    n = 0;
    return;         

end

