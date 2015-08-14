classdef bRawData < handle
    %BRAWDATA Batalef - Raw Data Object
    
    properties (SetAccess = public)
        Position % internal / external
        Matrix
        Fs
        AudioPath
        Operations
        Parent
        NSamples  % 
        NChannels
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
    end
    
    
    methods
        % CONSTRUCTOR
        function me = bRawData(position,matrix,Fs,operations,audioPath,parent)
            me.Position = position;
            me.Parent   = parent;            
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
                    me.Operations = operations;
                    [me.NSamples, me.NChannels]  = size(matrix);
                    
                case 'external'
                    % read file metadata
                    try
                        
                        meta = audioinfo(me.Application.physpath(audioPath));
                        me.AudioPath  = audioPath;
                        me.NChannels  = meta.NumChannels;
                        me.NSamples   = meta.TotalSamples;
                        me.Fs         = meta.SampleRate; 
                        me.Operations = cell(0,1); % clean slate for external source
                        
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
        function TS = getTS(me,channels,interval)
            if isempty(interval)
                interval = [1,me.NSamples];
            else
                interval = me.setIntervalBoundries(interval);
            end   
            if isempty(channels)
                channels = 1:me.NChannels;
            else
                channels = channels(channels <= me.NChannels);
            end
            
            switch me.Position
                case 'internal'
                    TS = me.Matrix(interval(1):interval(2),channels);
                case 'external'
                    TS = me.readAudio(interval);
                    TS = TS(:,channels);
                case 'empty'
                    TS = [];
                    return;
            end
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
            catch err
                if strcmp(err.identifier,'MATLAB:audiovideo:audioinfo:fileNotFound')
                    err = MException('batalef:rawData:readExternal:noFile',...
                        sprintf('Audio file "%s" unreachable. Can not load data',me.AudioPath));
                    throw(err);
                else
                    throw(err) % something else, don't handle here
                end                
            end
        end
        
        % SAVE TO FILE
        function saveToFile(me,newAudioPath)
            audiowrite( newAudioPath, me.Matrix, me.Fs ); 
        end
        
        % RETURN DATA STATUS
        function val = get.Status(me)
            if isempty(me.Operations)
                val = 'Raw';
            else
                val = '';
                if isempty(find(strcmp('Filter',me.Operations(:,1)),1))
                    val = strcat([val,'Filtered,',' ']);
                end
                if isempty(find(strcmp('UserFunction',me.Operations(:,1)),1))
                    val = strcat([val,'Altered through function,',' ']);
                end
                if isempty(find(strcmp('Trim',me.Operations(:,1)),1))
                    val = strcat([val,'Trimmed,',' ']);
                end
                if isempty(find(strcmp('Pad',me.Operations(:,1)),1))
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
        
        function val = get.FilePath(me)
            val = fileparts(me.Application.physpath(me.AudioPath));
        end
        function val = get.FileName(me)
            [~,val] = fileparts(me.AudioPath);
        end 
        function val = get.FileExtension(me)
            [~,~,val] = fileparts(me.AudioPath);
        end 

    end
    
end

