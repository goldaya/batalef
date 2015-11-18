classdef bFile < handle
    %BFILE Batalef - File Object
    
    properties
        ChannelCalls % a cell array containing the channels calls
        ChannelPoI   % a cell array containing the channels Points of Interest
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
        Length
        CallsCount
    end
    
    % STATIC METHODS
    methods (Static)
        
        % CRETAE NEW OBJECT
        function me = new(applicationObject,title,audioFile,parametersFile)
            me = bFile();
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
            me.initChannelCallsData();
            me.initPoiData();
            
            % microphones data
            me.MicData = bMics(n);
            
            % create file calls structure
            me.Calls = struct('time',[],'location',[],'sequence',[],'powers',[]);
            me.Calls(1) = [];
        end
        
        % BUILD OBJECT FROM STRUCTURE (IMPORT)
        function O = buildObject(X,applicationObject,rawDataObject,parametersObject,micsObject)
            O = bFile();
            O.Application = applicationObject;
            O.ChannelCalls = X.ChannelCalls;
            O.ChannelPoI   = X.ChannelPoI;
            O.Title        = X.Title;
            O.Calls        = X.Calls;
            if isempty(rawDataObject)
                O.RawData = bRawData.buildObject(X.RawData,O);
            else
                O.RawData = rawDataObject;
                O.RawData.Parent = O;
            end
            if isempty(parametersObject)
                O.Parameters = bParameters.buildObject(X.Parameters,applicationObject);
            else
                O.Parameters = parametersObject;
            end            
            if isempty(micsObject)
                O.MicData = bMics.buildObject(X.MicData);
            else
                O.MicData = micsObject;
            end

        end
        
    end    
    
    % INSTANCE METHODS
    methods
        
        % TRANSLATE TO EXPORTABLE STRUCTURE
        function X = toStruct(me,withRaw,discardAP)
            X = struct;
            X.ChannelCalls = me.ChannelCalls;
            X.ChannelPoI   = me.ChannelPoI;
            X.Title        = me.Title;
            X.RawData      = me.RawData.toStruct(withRaw);
            X.Parameters   = me.Parameters.toStruct();
            X.MicData      = me.MicData.toStruct();
            X.Calls        = me.Calls;
            X.RefDir       = me.Application.WorkingDirectory;
            
            if discardAP
                for j = 1:me.ChannelsCount
                    X.ChannelCalls{j}.featuresAP        = cell(0,1);
                    X.ChannelCalls{j}.forLocalizationAP = cell(0,1);
                    X.ChannelCalls{j}.forBeamAP         = cell(0,1);
                end                
            end
        end

        %%%%%%%%%%%%%%%%
        % CHANNEL DATA %
        %%%%%%%%%%%%%%%%
        
        % GET CHANNEL INTERFACE OBJECT
        function cobj = channel(me,j)
            cobj = bChannel(me,j);
        end
        
        % INIT CALLS DATA
        function initChannelCallsData(me)
            for j = 1:me.ChannelsCount
                me.ChannelCalls{j}.detection         = [];
                me.ChannelCalls{j}.features          = [];
                me.ChannelCalls{j}.ridge             = cell(0,1);
                me.ChannelCalls{j}.forLocalization   = [];
                me.ChannelCalls{j}.forBeam           = [];
                me.ChannelCalls{j}.featuresAP        = cell(0,1);
                me.ChannelCalls{j}.forLocalizationAP = cell(0,1);
                me.ChannelCalls{j}.forBeamAP         = cell(0,1);
            end
        end
        
        % INIT POI DATA
        function initPoiData(me)
            for j = 1:me.ChannelsCount
                me.ChannelPoI{j} = cell(0,4); % time, text, amplitude, freq
            end
        end
        
        % CLEAR CHANNEL CALLS FOR FILE
        function clearChannelCalls(me)
            arrayfun(@(j) me.initChannelCallsData(j),1:me.RawData.NChannels);
        end
        
        %%%%%%%%%%%%%%%
        % AUDIO STUFF %
        %%%%%%%%%%%%%%%
        
        % OVERWRITE AUDIOFILE
        function overwriteAudio(me)
            if strcmp(me.RawData.Position,'internal')
                me.RawData.saveToFile(me.Application.physpath(me.RawData.AudioPath));
            end
        end
        
        % FS
        function val = get.Fs(me)
            val = me.RawData.Fs;
        end
        
        % CHANNELS COUNT
        function val = get.ChannelsCount(me)
            val = me.RawData.NChannels;
        end
        
        % LENGTH
        function val = get.Length(me)
            val = me.RawData.Length;
        end
        
        %%%%%%%%%%%%%%
        % FILE CALLS %
        %%%%%%%%%%%%%%
        
        % ADD
        function addCall(me,sequence,time,location)
            cstrct.time     = time;
            cstrct.sequence = sequence;
            cstrct.location = location;
            cstrct.powers   = fileCallPowersMatrix(me,location,sequence);
            cstrct.beam     = [];
            
            % add and sort by time
            n = me.CallsCount;
            if n == 0
                me.Calls = cstrct;
            else
                me.Calls(me.CallsCount+1) = cstrct;
                A = [(1:me.CallsCount)',[me.Calls.time]'];
                A = sortrows(A,2);
                me.Calls = me.Calls(A(:,1));                
            end

        end
        
        % REMOVE
        function removeCall(me,callIdx)
            if callIdx > me.CallsCount
                
            else
                me.Calls(callIdx) = [];
            end
        end
        
        % GET CALL
        function out = call(me,callIdx)
            if callIdx > me.CallsCount
                out = [];
            else
                out = me.Calls(callIdx);
            end
        end
        function out = getCall(me,callIdx)
            if callIdx > me.CallsCount
                out = [];
            else
                out = me.Calls(callIdx);
            end
        end
        
        % SET CALL (use call() to get data struct, then return changes with
        % the set() function)
        function setCall(me,callIdx,callStruct)
            if callIdx > length(me.Calls)
                errid = 'batalef:fileCalls:wrongIndex';
                errstr = 'File call index is too large';
                throwAsCaller(MException(errid,errstr));
            end
            me.Calls(callIdx) = callStruct;
        end
        
        % GET FILE CALL'S POWERS TABLE
        function T = getCallPowers(me,callIdx)
            C = me.call(callIdx);
            P = C.powers;
            
            ChannelCall     = C.sequence';
            Measured        = [P.measured]';
            MicAmplif       = [P.micAmplif]';
            Distance        = [P.distMicBat]';
            Freq            = [P.freq]';
            AirAbsorbAmplif = [P.airAbsorbAmplif]';
            DirectAngle     = [P.angle]';
            DirectAmplif    = [P.directAmplif]';
            MA              = MicAmplif + AirAbsorbAmplif;
            MD              = MicAmplif + DirectAmplif;
            AD              = AirAbsorbAmplif + DirectAmplif;
            MDA             = MicAmplif + AirAbsorbAmplif + DirectAmplif;
            PowerAtBat      = Measured - MDA;
            PowerToUse      = [P.power2use]';
            
            T = table(ChannelCall,Measured,MicAmplif,Distance,Freq,AirAbsorbAmplif,DirectAngle,DirectAmplif,MA,MD,AD,MDA,PowerAtBat,PowerToUse);
        end
        
        % CALLS COUNT
        function val = get.CallsCount(me)
            val = length(me.Calls);
        end
                
        % GET FILE CALL MATCHING FOR A CHANNEL'S CALLS
        function out = getChannelFileCalls(me,channel2check)
            if isnumeric(channel2check)
                channelObj = me.channel(channel2check);
            elseif isa(channel2check,'bChannel')
                channelObj = channel2check;
                channel2check = channelObj.j;
            else
                errid = 'batalef:file:getChannelFileCalls:wrongInput';
                errstr = 'channel2check should either the channel object or its index';
                throwAsCaller(MException(errid,errstr));
            end
            
            if isempty(me.Calls)
                V = zeros(me.ChannelsCount,1);
            else
                S = vertcat(me.Calls.sequence);
                V = S(:,channel2check);
            end

            n = channelObj.CallsCount;
            out = zeros(n,1);
            for s = 1:n
                f = find(V==s,1);
                if isempty(f)
                    f = NaN;
                end
                out(s) = f;
            end
        end
        
        % GET TABLE
        function T = getCallsTable(me,withPowers)
            
            if isempty(me.Calls)
                T = {[]};
            else
                Time = [me.Calls.time]';
                L = vertcat(me.Calls.location);
                X = L(:,1);
                Y = L(:,2);
                Z = L(:,3);
                M = vertcat(me.Calls.sequence);

                T = table(Time,X,Y,Z);
                T.Properties.RowNames = arrayfun(@(i){num2str(i)},1:size(Time,1));

                for i = 1:size(M,2)
                    eval(sprintf('C%i = M(:,%i);T2 = table(C%i);',i,i,i));
                    T = horzcat(T,T2); %#ok<NODEF,AGROW>
                end

                if exist('withPowers','var') && withPowers
                    PowersMatrix = {me.Calls.powers}';
                    T2 = table(PowersMatrix);
                    T = horzcat(T,T2);
                end
            end
            
        end
            
            
        %%%%%%%%%%%%
        % GET DATA %
        %%%%%%%%%%%%
        
        % GET CHANNEL CALLS TABLE
        function T = getChannelCallsTable(me,withPoI,callType)
            nJ = me.ChannelsCount;
            C = arrayfun(@(j)me.channel(j).getChannelCallsTable(withPoI,callType),1:nJ,'UniformOutput',false);
            T1 = cell(nJ,1);
            for j = 1:nJ
                ChannelIdx = ones(size(C{j},1),1)*j;
                T1{j} = [table(ChannelIdx),C{j}];
            end
            T = vertcat(T1{:});
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
                    
                case {'TS','TimeSeries','TimeSignal'}
                    interval = getParFromVarargin('TimeInterval',varargin);
                    if islogical(interval) && ~interval
                        interval = [];
                    end
                    channels = getParFromVarargin('ChannelInterval',varargin);
                    if islogical(channels) && ~channels
                        channels = [];
                    end            
                    [TS,T] = me.RawData.getTS(channels,interval);
                    varargout{1} = TS;
                    varargout{2} = T;
                    
                otherwise
                    err = MException('batalef:fileData:wrongParameter',...
                        sprintf('No such parameter "%s"',varargin{1}));
                    throw(err);
            end
            
        end
        
    end
    
end
