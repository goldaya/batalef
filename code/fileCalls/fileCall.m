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
    
    methods (Access = public, Static)
        function deleted = removeCalls(K,M,testrun)
            global filesObject;
            deleted = false;
            
            for ik = 1:length(K)
                k = K(ik);
                times = fileData(k,'Calls','Times');
                
                if isempty(M)
                    if ~isempty(times)
                        deleted = true;
                        if testrun
                            return;
                        end
                        A = 1:length(times);
                        filesObject(k).fileCalls(A)=[];
                    end
                elseif iscell(M) % by index
                    A = cell2mat(M);
                    A = A(A<=fileData(k,'Calls','Count'));
                    if ~isempty(A)
                        deleted = true;
                        if testrun
                            return;
                        end
                        filesObject(k).fileCalls(A)=[];
                    end
                    
                else
                    A = 1:length(times);
                    Ia = times >= M(1);
                    Ib = times <= M(2);
                    I = logical(Ia .* Ib);
                    A = A(I);
                    if ~isempty(A)
                        deleted = true;
                        if testrun
                            return;
                        end
                        filesObject(k).fileCalls(A)=[];
                    end
                end
                    
            end
        end
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
            elseif me.ChannelCalls(j) <= s + n - 1
                me.ChannelCalls(j) = 0;
            else
                me.ChannelCalls(j) = me.ChannelCalls(j) - n;
            end
            me.save();
        end
        
        function remove(me)
            global filesObject;
            filesObject(me.FileIdx).fileCalls(me.CallIdx)=[];
        end
        
        
    end
    
end

