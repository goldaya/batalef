function [ channelObject ] = exportChannelObject( k, j, export )
%EXPORTCHANNELOBJECT Summary of this function goes here
%   Detailed explanation goes here

    validateFileChannelIndex(k,j);

    channelObject.Fullpath = fileData(k,'Fullpath');
    channelObject.Channel = j;
    channelObject.Fs = fileData(k,'Fs');
    channelObject.nSamples = fileData(k,'nSamples');
    channelObject.Calls = channelData(k,j,'Calls', 'Matrix');
    channelObject.CallsExplained = channelData(k,j,'Calls', 'Header');
    channelObject.CallsTS = channelData(k,j,'Calls', 'TS');
    channelObject.CallsRidges = channelData(k,j,'Calls', 'Ridge');
    
    if exist('export','var') && export
        assignin('base', 'channelObject', channelObject)
    end
    
end

