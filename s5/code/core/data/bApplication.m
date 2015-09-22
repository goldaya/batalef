classdef bApplication < handle

    properties (Access = private)
       Files = cell(0)
    end
    
    properties (GetAccess = public, SetAccess = private)
        CommonParams
        BatalefDirectory
        WorkingDirectory
        Methods
    end
    
    properties (Access = public)
        gpuProcAllowed = false
        parProcAllowed = false
    end
    
    properties (Dependent = true)
        FilesCount
        TempDirectory
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
        
        % DESTRUCTOR
        function delete(me)
            cellfun(@(f) delete(f),me.Files);
            M = fields2cell(me.Methods);
            cellfun(@(m) delete(m),M);            
        end
        
        % GET COMMON PARAMETERS
        function val = getCommonDefaults(me,type)
            commonFile = strcat(me.BatalefDirectory,filesep(),'user',filesep(),'tmp',filesep(),'commonParams.mat');
            copyfile(me.CommonParams.(type),commonFile,'f');
            val = load(commonFile);
        end
            
        
        % GET FULL PHYSICAL PATH
        function val = physpath(me,path)
            val = strcat(me.WorkingDirectory,filesep(),path);
        end
        function val = batpath(me, path)
            val = strcat(me.BatalefDirectory,filesep(),path);
        end
        
        % --- FILES HANDLING---
        
        % ADD FILE TO APPLICATION
		function [FileIdx] = addFile(me,audioFile,parametersFile)
            [~,title] = fileparts(audioFile);
            fileobj = bFile(me,title,audioFile,parametersFile);
            n = length(me.Files);
            me.Files{n+1} = fileobj;
            FileIdx = n+1;
        end
        
        % REMOVE FILE FROM APPLICATION
        function removeFiles(me,filesIdx)
            delete(me.Files(filesIdx));
            me.Files(filesIdx) = [];
            % some extra work for file calls etc...
        end
        
        % GET FILE INSTANCE
        function fileObj = file(me,fileIdx)
            me.validateFileIdx(fileIdx);
            fileObj = me.Files{fileIdx};
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
        
        % GET FILE PARAMETER
        function pValue = getFileParameter(me,fileIdx,pName)
            me.validateFileIdx(fileIdx);
            pValue = me.Files{fileIdx}.Parameters.get(pName);
        end
        function setFileParameter(me,fileIdx,pName,pValue)
            me.validateFileIdx(fileIdx);
            me.Files{fileIdx}.Parameters.set(pName,pValue);
        end
        
        % GET DATA FUNCTIONS
        function out = getAppData(me,varargin)
            switch varargin{1}
                case 'Files'
                    switch varargin{2}
                        case 'Count'
                            out = me.FilesCount;
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
        
        % TEMP FOLDER
        function val = get.TempDirectory(me)
            val = strcat(me.BatalefDirectory,filesep(),'user',filesep(),'tmp');
        end
            
    end
end
