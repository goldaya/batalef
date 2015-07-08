classdef fileCall < handle
    %FILECALL Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        FileIdx
        CallIdx
        Time
        Location
        ChannelCalls
        BeamData
    end
    
    methods (Access = public)
        
        % CONSTRUCTOR %%%%%
        function me = fileCall(k,a)
            global filesObject;
            call = filesObject(k).fileCalls{a};
            me.FileIdx = k;
            me.CallIdx = a;
            me.ChannelCalls = call.channelCalls;
            me.Time         = call.time;
            me.Location     = call.location;
            me.BeamData     = call.beam;
        end
        
        % SAVE
        function save(me)
            global filesObject;
            call.channelCalls = me.ChannelCalls;
            call.time         = me.Time;
            call.location     = me.Location;
            call.beam         = me.BeamData;
            filesObject(me.FileIdx).fileCalls{me.CallIdx} = call;
        end
        
        % CHECK CHANNEL CALL IS IN FILE CALL DATA
        function out = hasChannelCall(me, j, s)
            out = me.ChannelCalls(j) == s;
        end
        
        % PULL / PUSH channel calls after channel calls removal
        function changeChannelCallsAfterRemoval(me, j, s, n)
            if me.ChannelCalls(j) < s
                return;
            elseif me.ChannelCalls(j) <= s + n
                me.ChannelCalls(j) = 0;
            else
                me.ChannelCalls(j) = me.ChannelCalls(j) - n;
            end
            me.save();
        end
        
        
    end
    
end

