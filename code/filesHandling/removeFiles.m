function removeFiles( filesIndexes )
%REMOVEFILES Remove files from batalef

    global filesObject;
    filesObject(filesIndexes) = [];

end

