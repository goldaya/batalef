function [ channelCalls ] = exportChannelCalls( k,j,export )
%EXPORTCHANNELCALLS Export Channel Calls to base workspace

    TS = channelData(k,j,'Calls','TS');
    Ridges = channelData(k,j,'Calls','Ridge');
    channelCalls = {TS,Ridges};
    if exist('export','var') && export
        assignin('base', 'channelCalls', channelCalls)
    end    
    
end

