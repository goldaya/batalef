classdef bApplication < handle

    properties (Access = public)
       Files = cell(0);
       FilesSingleParamsFileInner = false;
    end
    
    properties (GetAccess = public, SetAccess = private)
        CommonParams
        BatalefDirectory
        WorkingDirectory
        Methods
        Parameters
    end
    
    properties (Access = public)
        GpuProcAllowed = false
        ParProcAllowed = false
    end
    
    properties (Dependent = true)
        FilesCount
        TempDirectory
        FilesSingleParamsFile
    end
    
	methods
        
        % CONSTRUCTOR
        function me = bApplication(batalefDirectory,workingDirectory)
            me.BatalefDirectory = batalefDirectory;
            me.WorkingDirectory = workingDirectory;
            me.CommonParams.app  = me.batpath(strcat('common',filesep(),'common.bap'));
            me.CommonParams.gui  = me.batpath(strcat('common',filesep(),'common.bgp'));
            me.CommonParams.file = me.batpath(strcat('common',filesep(),'common.bfp'));
        end
        
        % INIT METHODS
        function initMethods(me)
            me.Methods.preProcFilter = bMethodFilter('onDemend','preProcFilter',me,[],false);
            me.Methods.channelCallsDetection = bMethodDetection('onDemend','channelCallsDetection',me,[],false);
            me.Methods.detectionFilter = bMethodFilter('default','detectionFilter',me,[],true);
            me.Methods.detectionEnvelope = bMethodEnvelope('default','detectionEnvelope',me,[],false);
            me.Methods.callAnalysisFilter = bMethodFilter('default','callAnalysisFilter',me,[],true);
            me.Methods.callAnalysisEnvelope = bMethodEnvelope('default','callAnalysisEnvelope',me,[],false);
            me.Methods.callAnalysisSpectrogram = bMethodSpectrogram('default','callAnalysisSpectrogram',me,[],false);
            me.Methods.callAnalysisSpectrum = bMethodSpectrum('default','callAnalysisSpectrum',me,[],false);
            me.Methods.callAnalysisRidge = bMethodRidge('default','callAnalysisRidge',me,[],false);
                
        end
        
        % DESTRUCTOR
        function delete(me)
            cellfun(@(f) delete(f),me.Files);
            [M,~] = fields2cell(me.Methods);
            cellfun(@(m) delete(m),M);
            delete(me.Parameters);
        end
        
        %%%%%%%%%%%%%%%%%%%%
        % FOLDERS HANDLING %
        %%%%%%%%%%%%%%%%%%%%
        
        % GET FULL PHYSICAL PATH
        function val = physpath(me,path)
            val = strcat(me.WorkingDirectory,filesep(),path);
        end
        function val = batpath(me, path)
            val = strcat(me.BatalefDirectory,filesep(),path);
        end        
        
        % TEMP FOLDER
        function val = get.TempDirectory(me)
            val = strcat(me.BatalefDirectory,filesep(),'user',filesep(),'tmp');
        end        
        
        %%%%%%%%%%%%%%%%%%
        %%% PARAMETERS %%%
        %%%%%%%%%%%%%%%%%%
        
        % SET PARAMETERS
        function setParameters(me, paramsFile)
            me.Parameters = bParameters(me,'app');
            me.Parameters.loadFromFile(paramsFile);
        end
        
        % FILES PARAMETERS HANDLED BY SINGLE PARAMETERS FILE
        function val = get.FilesSingleParamsFile(me)
            val = me.FilesSingleParamsFileInner;
        end
        function set.FilesSingleParamsFile(me,turnOn)
            me.FilesSingleParamsFileInner = turnOn;
            if turnOn
                if me.FilesCount > 1
                    parObj = me.Files{1}.Parameters.clone();
                    for i = 1:me.FilesCount
                        delete(me.Files{i}.Parameters);
                        me.Files{i}.Parameters = parObj;
                    end
                end
            else % turn off. handle each file separately
                if me.FilesCount > 1
                    parObj = me.Files{1}.Parameters.clone();
                    for i = 2:me.FilesCount
                        me.Files{i}.Parameters = parObj.clone();
                    end
                end
            end
        end
        
        % GET COMMON PARAMETERS
        function val = getCommonDefaults(me,type)
            commonFile = strcat(me.BatalefDirectory,filesep(),'user',filesep(),'tmp',filesep(),'commonParams.mat');
            copyfile(me.CommonParams.(type),commonFile,'f');
            val = load(commonFile);
        end
            
               
        %%%%%%%%%%%%%%%%%%
        % FILES HANDLING %
        %%%%%%%%%%%%%%%%%%
                
        % ADD FILE TO APPLICATION
		function [FileIdx] = addFile(me,audioFile,parametersFile)
            [~,title] = fileparts(audioFile);
            if ~isempty(parametersFile) && me.FilesSingleParamsFile && me.FilesCount > 0
                errstr = 'Cannot add parameters file on "Single Parameters File for Files" mode.';
                errid  = 'batalef:parameters:newfileViolatesSingleFileConstraint';
                err    = MException(errid,errstr);
                throwAsCaller(err);
            elseif isempty(parametersFile)
                parametersFile = me.Files{1}.Parameters;
            end
            fileobj = bFile(me,title,audioFile,parametersFile);
            n = length(me.Files);
            me.Files{n+1} = fileobj;
            FileIdx = n+1;
        end
        
        % REMOVE FILE FROM APPLICATION
        function removeFiles(me,filesIdx)
            cellfun(@(f)delete(f),me.Files(filesIdx));
            me.Files(filesIdx) = [];
            % some extra work for file calls etc...
        end
        
        % GET FILE INSTANCE
        function fileObj = file(me,fileIdx)
            me.validateFileIdx(fileIdx);
            fileObj = me.Files{fileIdx};
        end
        
        % SAVE LOAD / FILES PARAMETERS
        function saveFileParams(me,relFilePath,I)
            if isempty(I)
                I = 1:me.FilesCount;
            end
            cellfun(@(f) f.Parameters.saveToFile(relFilePath),me.Files(I));
        end
        function loadFileParams(me,relFilePath,I)
            if isempty(I)
                I = 1:me.FilesCount;
            end
            cellfun(@(f) f.Parameters.loadFromFile(relFilePath),me.Files(I));
        end
        
        % VALIDATE FILE INDEX
        function validateFileIdx(me,idx)
            if me.FilesCount < idx
                errstr = sprintf('The requested index %i is greater than total number of assigned files %i',idx,me.FilesCount);
                err = MException('batalef:files:wrongIndex:tooBig',errstr);
                throwAsCaller(err);
            end
        end
        
        % FILES COUNT
        function val = get.FilesCount(me)
            val = length(me.Files);
        end
        

        %%%%%%%%%%%%%%%%%%%%%%
        % GET DATA FUNCTIONS %
        %%%%%%%%%%%%%%%%%%%%%%
        
        % GET FILE PARAMETER
        function pValue = getFileParameter(me,fileIdx,pID,varargin)
            me.validateFileIdx(fileIdx);
            pValue = me.Files{fileIdx}.Parameters.get(pID,varargin{:});
        end
        function setFileParameter(me,fileIdx,pName,pValue)
            me.validateFileIdx(fileIdx);
            me.Files{fileIdx}.Parameters.set(pName,pValue);
        end
        
        % GET DATA FUNCTIONS
        function varargout = getAppData(me,varargin)
            switch varargin{1}
                case 'Files'
                    switch varargin{2}
                        case 'Count'
                            varargout{1} = me.FilesCount;
                    end
                case 'ParProc'
                    switch varargin{2}
                        case 'Allowed'
                            varargout{1} = me.ParProcAllowed;
                    end
            end
        end
        function varargout = getFileData(me,fileIdx, varargin)
            me.validateFileIdx(fileIdx);
            [varargout{1:nargout}] = me.Files{fileIdx}.getData(varargin{:});
        end
        function varargout = getChannelData(me,fileIdx, channelIdx, varargin)
            me.validateFileIdx(fileIdx);
            [varargout{1:nargout}] = me.Files{fileIdx}.channel(channelIdx).getData(varargin{:});
        end     
        
            
    end
end
