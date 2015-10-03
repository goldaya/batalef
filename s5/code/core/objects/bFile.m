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
            if isa(parametersFile,'bParameters')
                me.Parameters = parametersFile;
            else
                me.Parameters = bParameters(me.Application,'file');
                me.Parameters.loadFromFile(parametersFile);
            end
            
            % create raw data object
            me.RawData = bRawData(me.Parameters.get('rawData_position'),[],[],[],audioFile,me);

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
            me.ChannelPoI{j}   = cell(0,4); % time, text, amplitude, freq
        end

	% GET CHANNEL INTERFACE OBJECT
        function cobj = channel(me,j)
            cobj = bChannel(me,j);
        end
        
        % GET DATA
        function varargout = getData(me, varargin)
            varargout = {};
            if isempty(varargin)
                return;
            end
            switch varargin{1}
                case 'Title'
                    varargout{1} = me.Title;
                    
                case 'Name'
                    varargout{1} = strcat(me.RawData.FileName,me.RawData.FileExtension);
                    
                case 'Channels'
                    switch varargin{2}
                        case 'Count'
                            varargout{1} = me.RawData.NChannels;
                    end
                    
                case 'Calls'
                    switch varargin{2}
                        case 'Count'
                            varargout{1} = size(me.Calls,1);
                    end
                case 'Ylim'
                    varargout{1} = me.RawData.Ylim;
                    
                case 'Length'
                    varargout{1} = me.RawData.Length;
                    
                case 'Fs'
                    varargout{1} = me.RawData.Fs;
                    
                case 'DataStatus'
                    varargout{1} = me.RawData.Status;
                    
                otherwise
                    err = MException('batalef:fileData:wrongParameter',...
                        sprintf('No such parameter "%s"',varargin{1}));
                    throw(err);
            end
            
        end
        
    end
    
end
