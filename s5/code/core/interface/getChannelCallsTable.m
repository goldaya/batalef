function [ T ] = getChannelCallsTable( appObject, files, withPoI, callType )
%GETCHANNELCALLSTABLE Returns a Matlab table object with the channel call
%data + points of interest
%   appObject:  handle of the batalef application object
%   files:      indexes of files to output
%   channels:   indexes of channels to output. [] for all channels
%   withPoI:    output points of interest?


    F = arrayfun(@(f)doForFile(appObject,f,withPoI,callType),files,'UniformOutput',false);
    T = vertcat(F{:});

end

function [T] = doForFile(appObject,k,withPoI,callType)

    file = appObject.file(k);
    F = file.getChannelCallsTable(withPoI,callType);
    FileIdx = ones(size(F,1),1)*k;
    T = [table(FileIdx),F];
    
end

