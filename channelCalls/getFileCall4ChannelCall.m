function [ fileCallIdx ] = getFileCall4ChannelCall( k,j,s )
%GETFILECALL4CHANNELCALL Summary of this function goes here
%   Detailed explanation goes here

    global filesObject;
    
    n = fileData(k, 'Calls','Count','NoValidation',true);
    for a = 1:n
        if filesObject(k).fileCalls{a}.channelCalls(j)==s
            fileCallIdx = a;
            return;
        end
    end
    
    fileCallIdx = 0;

end

