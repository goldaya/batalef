function [  ] = deleteFileCall( k, a )
%DELETEFILECALL Summary of this function goes here
%   Detailed explanation goes here

    global filesObject;
    
    n = fileData(k, 'Calls', 'Count');
    if n >= a
        filesObject(k).fileCalls(a)=[];
    end
    
end

