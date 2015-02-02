function [  ] = changeFileCall( k, a, varargin )
%CHANGEFILECALL Summary of this function goes here
%   Detailed explanation goes here

    global filesObject;
    
    if ~getParFromVarargin( 'NoValidation', varargin )
        validateFileCallIndex(k,a);
    end
    
    % read call
    call = filesObject(k).fileCalls{a};
    
    t = getParFromVarargin('Time',varargin);
    if t ~= false
        call.time = t;
    end
    
    x = getParFromVarargin('Location',varargin);
    if x ~= false
        call.location = x;
    end
            
    seq = getParFromVarargin('ChannelCalls',varargin);
    if seq ~= false
        call.channelCalls = seq;
    end
    
    filesObject(k).fileCalls{a} = call;
end

