classdef bRawData < handle
    %BRAWDATA Batalef - Raw Data Object
    
    properties (GetAccess = public)
        Position % internal / external
        Matrix
        Fs
        AudioPath
        Operations
        Parent
        NSamples  % 
        NChannels
        Ylim
    end
    
    properties (Constant)
        raw = 0;
        filtered = 1;
        userFunction = 3;
    end
    
    properties (Dependent)
        Status
        HasMatrix
        Application
        FileName
        FileExtension
        FilePath
        Length
    end
    
    
    methods
        % CONSTRUCTOR
        function me = bRawData(position,matrix,Fs,operations,audioPath,parent)
            me.Position = position;
            me.Parent   = parent;            
            me.Operations = operations;
            switch position
                case 'internal'
                    if isempty(matrix)
                        err = MException('batalef:rawData:create:internal:missing:matrix',...
                            'Tried to create an internal-holding raw-data object without data matrix');
                        throw(err);
                    end
                    if isempty(Fs) || Fs <= 0
                        err = MException('batalef:rawData:create:internal:missing:Fs',...
                            sprintf('Tried to create an internal-holding raw-data object with sampling rate "%0.3f"',Fs));
                        throw(err);
                    end
                    me.Matrix     = matrix;
                    me.Fs         = Fs;
                    [me.NSamples, me.NChannels]  = size(matrix);
                    me.Ylim = [min(min(matrix)),max(max(matrix))];
                    
                case 'external'
                    % read file metadata
                    try
                        me.Matrix = [];
                        meta = audioinfo(audioPath);
                        me.AudioPath  = audioPath;
                        me.NChannels  = meta.NumChannels;
                        me.NSamples   = meta.TotalSamples;
                        me.Fs         = meta.SampleRate; 
                        TS = me.readAudio([]);
                        me.Ylim = [min(min(TS)),max(max(TS))];
                        me.Operations = cell(0,2); % clean slate for external source
                        
                    catch err
                        if strcmp(err.identifier,'MATLAB:audiovideo:audioinfo:fileNotFound')
                            err = MException('batalef:rawData:create:external:noFile',...
                                sprintf('Audio file "%s" unreachable. Can not create raw-data object',audioPath));
                            throw(err);
                        else
                            throw(err) % something else, don't handle here
                        end
                    end
                case 'empty'
                    % create empty object. useful ??
                otherwise
                    err = MException('batalef:rawData:create:wrongPosition',...
                        sprintf('The data position specified ("%s") is invalid',position));
                    throw(err)
            end

        end
        
        % SET INTERVAL BOUNDRIES
        function interval = setIntervalBoundries(me, interval)
            if interval(1) < 1
                interval(1) = 1;
            end
            if interval(2) > me.NSamples
                interval(2) = me.NSamples;
            end            
        end

        % RETURN TS (WHOLE OR PART)
        function [TS,T] = getTS(me,channels,timeInterval)
        %[TS,T]=GETTS(channels,timeInterval)
        %   channels     = [] for all channels
        %   timeInterval = [] for whole TS
            if isempty(timeInterval)
                samplesInterval = [1,me.NSamples];
            else
                samplesInterval = me.time2samples(timeInterval);
            end   
            if isempty(channels)
                channels = 1:me.NChannels;
            else
                channels = channels(channels <= me.NChannels);
                if isempty(channels)
                    warnid  = 'batalef:rawData:emptyRequest';
                    warnstr = 'The channels you requested are out of the file scope';
                    warning(warnid,warnstr);
                    TS = [];
                    T  = [];
                    return;
                end
            end
            
            % Time Signal
            switch me.Position
                case 'internal'
                    TS = me.Matrix(samplesInterval(1):samplesInterval(2),channels);
                case 'external'
                    TS = me.readAudio(samplesInterval);
                    TS = TS(:,channels);
                case 'empty'
                    TS = [];
                    T  = [];
                    return;
            end
            
            % Time coordinates
            T = (samplesInterval(1):samplesInterval(2))./me.Fs;
        end
        
        
        % READ DATA FROM FILE
        function [TS, Fs] = readAudio(me,interval)
            phys = me.Application.physpath(me.AudioPath);
            try
                if isempty(interval)
                    [TS,Fs] = audioread(phys);
                else
                    interval = me.setIntervalBoundries(interval);
                    [TS,Fs] = audioread(phys,interval);
                end
            
            catch err
                if strcmp(err.identifier,'MATLAB:audiovideo:audioread:invalidrange')
                    err = MException('batalef:rawData:readExternal:wrongInterval',...
                        sprintf('Reading audio file "%s" with wrong interval "[%i,%i]"',me.AudioPath,interval(1),interval(2)));
                    throw(err);                    
                elseif strcmp(err.identifier,'MATLAB:audiovideo:audioinfo:fileNotFound')
                    err = MException('batalef:rawData:readExternal:noFile',...
                        sprintf('Audio file "%s" unreachable. Can not load data',me.AudioPath));
                    throw(err);                    
                else
                    throw(err) % something else, don't handle here
                end
            end
        end
        
        % LOAD DATA EXPLICITLY
        function loadExplicit(me)
            try
                [me.Matrix,me.Fs] = me.readAudio([]);
                [me.NSamples,me.NChannels] = size(me.Matrix);
                me.Position = 'internal';
                me.Operations = cell(0,2); % clean slate for loaded audio
            catch err
                if strcmp(err.identifier,'MATLAB:audiovideo:audioinfo:fileNotFound')
                    err = MException('batalef:rawData:readExternal:noFile',...
                        sprintf('Audio file "%s" unreachable. Can not load data',me.AudioPath));
                    throwAsCaller(err);
                else
                    err.rethrow() % something else, don't handle here
                end                
            end
        end
        
        % UNLOAD DATA EXPLICITLY
        function unloadExplicit(me)
            try
                me.Matrix = [];
                me.Position = 'external';
                meta = audioinfo(me.AudioPath);
                me.NChannels  = meta.NumChannels;
                me.NSamples   = meta.TotalSamples;
                me.Fs         = meta.SampleRate; 
                TS = me.readAudio([]);
                me.Ylim = [min(min(TS)),max(max(TS))];
                me.Operations = cell(0,2); % clean slate for external source

            catch err
                if strcmp(err.identifier,'MATLAB:audiovideo:audioinfo:fileNotFound')
                    err = MException('batalef:rawData:create:external:noFile',...
                        sprintf('Audio file "%s" unreachable. Can not create raw-data object',me.AudioPath));
                    throwAsCaller(err);
                else
                    rethrow(err) % something else, don't handle here
                end
            end            
        end
        
        % FILTER
        function filter(me,filterObject)
            me.Matrix = filter(filterObject,me.getTS([],[]));
            me.Position = 'internal';
            me.Operations = [me.Operations;{'Filter',NaN}];
        end
        
        % ALTER
        function alter(me,TS,operation,Fs)
        %ALTER change TS matrix, state internal data position and update
        %operations array
            me.Matrix = TS;
            [me.NSamples, me.NChannels]  = size(TS);
            me.Position = 'internal';
            me.Operations = [me.Operations;operation];            
            if exist('Fs','var')
                me.Fs = Fs;
            end
        end
        
        % SAVE TO FILE
        function saveToFile(me,newAudioPath)
            audiowrite( newAudioPath, me.Matrix, me.Fs ); 
        end
        
        % TRANSLATE TIME INTERVAL INTO SAMPLES INTERVAL
        function S = time2samples(me,T)
            S = arrayfun(@(t) min(max(round(t.*me.Fs),1),me.NSamples),T);
        end
        
        % RETURN DATA STATUS
        function val = get.Status(me)
            if isempty(me.Operations)
                val = 'Raw';
            else
                val = '';
                if isempty(find(strcmp('Filter',me.Operations(:,1)),1))
%                     val = strcat(val,'Filtered');
                    val = 'Filtered';
                end
                if isempty(find(strcmp('UserFunction',me.Operations(:,1)),1))
                    if ~isempty(val)
                        val = strcat([val,', ']);
                    end
                    val = strcat([val,'Altered through function,',' ']);
                end
                if isempty(find(strcmp('Trim',me.Operations(:,1)),1))
                    if ~isempty(val)
                        val = strcat([val,', ']);
                    end                    
                    val = strcat([val,'Trimmed,',' ']);
                end
                if isempty(find(strcmp('Pad',me.Operations(:,1)),1))
                    if ~isempty(val)
                        val = strcat([val,', ']);
                    end                    
                    val = strcat([val,'Padded,',' ']);
                end      
            end
        end
        
        % RETURN HAS DATA MATRIX
        function val = get.HasMatrix(me)
            if strcmp(me.Position,{'external','empty'})
                val = false;
            elseif isempty(me.Matrix)
                val = false; % error ?
            else
                val = true;
            end
        end
        
        % RETURN APPLICATION CONTROL OBJECT
        function obj = get.Application(me)
            obj = me.Parent.Application;
        end
        
        %
        function val = get.FilePath(me)
            val = fileparts(me.Application.physpath(me.AudioPath));
        end
        function val = get.FileName(me)
            [~,val] = fileparts(me.AudioPath);
        end 
        function val = get.FileExtension(me)
            [~,~,val] = fileparts(me.AudioPath);
        end 
        
        % LENGTH
        function val = get.Length(me)
            val = me.NSamples / me.Fs;
        end

    end
    
end

