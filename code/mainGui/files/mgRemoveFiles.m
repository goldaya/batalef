function [ output_args ] = mgRemoveFiles( input_args )
%MGREMOVEFILES Summary of this function goes here
%   Detailed explanation goes here

    global filesObject;
    K = mgResolveFilesToWork();
    if isempty(K)
        return;
    end
    
    filesObject(K) = [];
    
    global control;
    control.mg.k = 0;
    mgRefreshFilesTable();
    mgRefreshDisplay();
    
end

