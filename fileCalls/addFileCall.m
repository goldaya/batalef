function [ idx ] = addFileCall( k, channelCalls )
%ADDFILECALL Summary of this function goes here
%   Detailed explanation goes here

    global filesObject;

    MicPositions = fileData(k, 'Mics');
    channelCallsTimes = seqChannelCallsTimes( k, channelCalls );
    
    % approximate time of call and position
    [t, x] = approxCallTimeLocation(channelCallsTimes, MicPositions);
    
    % put new call in the right place
    m = fileData(k,'Calls','Count');
    if m~=0
        for w = 1:m
            a = m-w+1; % start from last and go back
            ts = fileCallData(k,a,'Time');
            if ts > t
                filesObject(k).fileCalls{a+1} = filesObject(k).fileCalls{a};
            else
                createFileCall(k, a+1, channelCalls, t, x, true);
                idx = a+1;
                return;
            end
        end
    end
    
    % looped through whole array and did not find a something earlier ? put it in the
    % 1st place !
    createFileCall(k, 1, channelCalls, t, x, true);
    idx = 1;
end

