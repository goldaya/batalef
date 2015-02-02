function [  ] = createFileCall( k, a, channelCalls, callTime, callLocation, noValidation )
%CREATEFILECALL Fill in the file call data in the indicated index
%   Detailed explanation goes here

    global filesObject;

    if ~exist('noValidation','var') || ~noValidation
        validateFileIndex(k);
        V = fileCallData( k, a, 'ChannelCalls' );
        if ~isempty(V)
            err = MException('bats:fileCalls:alreadyExist','File call &d already exist',a);
            throw( err );
        end  
    end
    
    call.channelCalls = channelCalls;
    call.time = callTime;
    call.location = callLocation;
    call.beam = struct('leads',[],'raw',[],'interpolated',[],'coordinates',[],'micDirections',[]);
    
    filesObject(k).fileCalls{a} = call;

end

