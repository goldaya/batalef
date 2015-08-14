classdef bApplication < handle

    properties (Access = private)
       CommonParams
       
    end
    
    properties (Access = public)
        WorkingDirectory
        Files = cell(0)
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
            
        % ADD FILE TO APPLICATION
		function [FileIdx] = addFile(me,audioFile,parametersFile)
            [~,title] = fileparts(audioFile);
            fileobj = bFile(me,title,audioFile,parametersFile);
            n = length(me.Files);
            me.Files{n+1} = fileobj;
            FileIdx = n+1;
        end
        
        % GET FULL PHYSICAL PATH
        function val = physpath(me,path)
            val = strcat(me.WorkingDirectory,filesep(),path);
        end
                
    end
end
