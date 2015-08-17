classdef bApplication < handle

    properties (Access = private)
       CommonParams
       Files = cell(0)
    end
    
    properties (Access = public)
        WorkingDirectory
    end
    
    properties (Dependent = true)
        FilesCount
    end
    
	methods
        
        % CONSTRUCTOR
        function me = bApplication(workingDirectory,appCommonParams,fileCommonParams)
            me.WorkingDirectory = workingDirectory;
            me.loadCommonParameters('application',me.physpath(appCommonParams));
            me.loadCommonParameters('file',me.physpath(fileCommonParams));
        end
        
        % LOAD COMMON PARAMETERS
        function loadCommonParameters(me,type,filepath)
            fid = fopen(filepath);
            A = textscan(fid, '%s %s %f'); % name, type, value(float)
            fclose(fid);
            A{3} = num2cell(A{3});
            me.CommonParams.(type) = A;
        end
        
        % GET COMMON PARAMETERS
        function val = getCommonDefaults(me,type)
            val = me.CommonParams.(type);
        end
            
        
        % GET FULL PHYSICAL PATH
        function val = physpath(me,path)
            val = strcat(me.WorkingDirectory,filesep(),path);
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
        function removeFile(me,fileIdx)
            me.validateFileIdx(fileIdx);
            me.Files(fileIdx) = [];
        end
        
        % GET FILE INSTANCE
        function fileObj = file(me,fileIdx)
            me.validateFileIdx(fileIdx);
            fileObj = me.Files{fileIdx};
        end
        
        % VALIDATE FILE INDEX
        function validateFileIdx(me,idx)
            if length(me.Files) < idx
                errstr = sprintf('The requested index %i is greater than total number of assigned files %i',idx,length(me.Files));
                err = MException('batalef:files:wrongIndex:tooBig',errstr);
                throw(err);
            end
        end
        
        % FILES COUNT
        function val = get.FilesCount(me)
            val = length(me.Files);
        end
                
    end
end
