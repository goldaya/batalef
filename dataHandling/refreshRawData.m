function [  ] = refreshRawData( k, withDataMatrix )
%REFRESHRAWDATA Refresh file's raw data
    
    global filesObject;
    validateFileIndex(k);
    fullpath = fileData(k,'Fullpath');
    if ~exist('withDataMatrix','var');
        withDataMatrix = getParam('rawData:loadWithMatrix');
    end
    
    filesObject(k).rawData = readRawDataFromFile(fullpath,withDataMatrix);

end

