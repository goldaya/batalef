function [  ] = exportChannelCallObject( k,j,s )
%EXPORTCHANNELCALLOBJECT Summary of this function goes here
%   Detailed explanation goes here

    validateFileChannelCallIndex(k,j,s);
    
    callObject.Fullpath = fileData(k,'Fullpath');
    callObject.Channel = j;
    callObject.Call = s;
    callObject.Fs = fileData(k,'Fs');
    callObject.Start = channelCallData(k,j,s,'Start');
    callObject.Peak = channelCallData(k,j,s,'Peak');
    callObject.End = channelCallData(k,j,s,'End');
    callObject.Duration = channelCallData(k,j,s,'Duration');
    callObject.TS = channelCallData(k,j,s,'TS');
    callObject.Ridge = channelCallData(k,j,s,'Ridge');
    
    assignin('base', 'channelCallObject', callObject)    
    
end

