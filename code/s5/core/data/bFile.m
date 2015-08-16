classdef bFile < handle
    %BFILE Batalef - File Object
    
    properties (Access = ?bChannel)
        ChannelCalls % a cell array containing the channels calls
        ChannelPoI   % a cell array containing the channels Points of Interest
    end

    properties
        Title
        RawData
        Parameters
        MicData
        Application
        Calls % file level calls
    end
    
    properties (Dependent = true)
        Fs
        ChannelsCount
    end
    
    methods
        % CONSTRUCTOR
        function me = bFile(applicationObject,title,audioFile,parametersFile)
            me.Application = applicationObject;
            me.Title = title;
            
            % create parameters object
            me.Parameters = bParameters(me,'file');
            me.Parameters.loadFromFile(parametersFile);
            
            % create raw data object
            me.RawData = bRawData('external',[],[],[],audioFile,me);

            % create channel data structures
            n = me.RawData.NChannels;
            me.ChannelCalls = cell(1,n);
            me.ChannelPoI   = cell(1,n);
            arrayfun(@(j) me.initChannelData(j),[1:n]);
        end

        % INITIALIZE CHANNEL DATA STRUCTURES
        function initChannelData(me,j)
            me.ChannelCalls{j}.detection = [];
            me.ChannelCalls{j}.features  = [];
            me.ChannelCalls{j}.ridge     = cell(0,1);
            me.ChannelCalls{j}.forLocalization = [];
            me.ChannelCalls{j}.forBeam   = [];
            me.ChannelPoI{j}   = cell(0,3);
        end

	% GET CHANNEL INTERFACE OBJECT
        function cobj = Channel(me,j)
            cobj = bChannel(me,j);
        end
    end
    
end
