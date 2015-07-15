function [  ] = addFileObject( fileObject )
%ADDFILEOBJECT Summary of this function goes here
%   Detailed explanation goes here

    global filesObject;
    
    % check object  is a valid file-object
    
    % check does not already exist
    
    
    % add to fileObjects    
    k = length(filesObject)+1;
    fileObject = fileObject(1);
    createFileObject( k,...
        fileObject.fullname,...
        fileObject.rawData,...
        fileObject.spectralData,...
        fileObject.fileCalls,...
        fileObject.channels,...
        fileObject.mics )
end

