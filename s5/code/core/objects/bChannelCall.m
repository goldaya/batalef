classdef bChannelCall < handle
    %BCHANNELCALL Handling single channel call data
    
    properties
        Channel
        CallIdx
        CallType = 'features';
        Detection
        Start
        Peak
        End
        Ridge
        AnalysisParameters
    end
    
    properties (Dependent = true)
        Duration
        TS
        Fs
        Application
    end
    
    methods
        
        % CONSTRUCTOR
        function me = bChannelCall(channelObject, callIdx)
            me.Channel = channelObject;
            me.CallIdx = callIdx;
            me.init();
        end
           
        % INITIALIZE
        function init(me)
            me.Detection.Time  = me.Channel.CallsData.detection(me.CallIdx,1);
            me.Detection.Value = me.Channel.CallsData.detection(me.CallIdx,2);
            
            me.Start.Time  = 0;
            me.Start.Value = 0;
            me.Start.Freq  = 0;
            me.Start.Power = 0;
            
            me.Peak.Time  = 0;
            me.Peak.Value = 0;
            me.Peak.Freq  = 0;
            me.Peak.Power = 0;
            
            me.End.Time  = 0;
            me.End.Value = 0;
            me.End.Freq  = 0;
            me.End.Power = 0;
            
            me.Ridge = [];
            me.AnalysisParameters = {};
        end
        
        % LOAD DATA
        function loadCall(me,type)
            
            me.CallType = type;
            switch type
                case 'features'
                    me.Ridge = me.Channel.CallsData.ridge{me.CallIdx};
                case 'forLocalization'
                    me.Ridge = [];
                case 'forBeam'
                    me.Ridge = [];
                otherwise
                    errid  = 'batalef:channelCall:wrongType';
                    errstr = sprintf('Wrong channel call type: %s',type);
                    err = MException(errid,errstr);
                    throwAsCaller(err);
            end
            
            D = me.Channel.CallsData.(type)(me.CallIdx,:);
            me.Start.Time  = D(1);
            me.Start.Value = D(2);
            me.Start.Freq  = D(3);
            me.Start.Power = D(4);
            me.Peak.Time  = D(5);
            me.Peak.Value = D(6);
            me.Peak.Freq  = D(7);
            me.Peak.Power = D(8);
            me.End.Time  = D(9);
            me.End.Value = D(10);
            me.End.Freq  = D(11);
            me.End.Power = D(12);
            
            me.AnalysisParameters = me.Channel.CallsData.(strcat(type,'AP')){me.CallIdx};
            
        end
        
        % SAVE DATA
        function saveCall(me,type)
            if ~exist('type','var')
                type = me.CallType;
            end
            
            D = [...
                me.Start.Time,...
                me.Start.Value,...
                me.Start.Freq,...
                me.Start.Power,...
                me.Peak.Time,...
                me.Peak.Value,...
                me.Peak.Freq,...
                me.Peak.Power,...
                me.End.Time,...
                me.End.Value,...
                me.End.Freq,...
                me.End.Power,...
                ];
        
            me.Channel.CallsData.(type)(me.CallIdx,:) = D;
            me.Channel.CallsData.(strcat(type,'AP')){me.CallIdx} = me.AnalysisParameters;
            if strcmp(type,'features')
                me.Channel.CallsData.ridge{me.CallIdx} = me.Ridge;
            end
            
        end
        
        % DURATION
        function val = get.Duration(me)
            val = me.End.Time - me.Start.Time;
        end
        
        % Fs
        function val = get.Fs(me)
            val = me.Channel.Fs;
        end
        
        % TS
        function val = get.TS(me)
            val = me.Channel.getTS([me.Start.Time,me.End.Time]);
        end
        
        % IPI
        function val = getIPI(me,callType)
            if me.CallIdx > 1
                D = me.Channel.CallsData.(callType);
                lastCallStart = D(me.CallIdx-1,1);
                if lastCallStart > 0
                    val = me.Start.Time - lastCallStart;
                else
                    val = [];
                end
            else
                val = [];
            end
        end
        
        % APPLICATION
        function val = get.Application(me)
            val = me.Channel.Application;
        end
    end
    
end

