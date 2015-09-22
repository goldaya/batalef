classdef bParameters < handle
    %BPARAMETERS Parameters object
    
    properties (SetAccess = private, GetAccess = public)
        File
        Type
        Parent % application / file / gui object
        Params
    end
    
    properties (Dependent = true)
        Application
    end
  
    methods
        % CONSTRUCTOR
        function me = bParameters(parent,type)
            switch type
                case 'file'
                case 'application'
                case 'gui'
                otherwise
                    % error
                    err = MException('batalef:parameters:objectWrongType',sprintf('Parameters-object type %s is not allowed',type));
                    throw(err);
            end
            me.Type = type;
            me.Parent = parent; 
        end
        
        
        % LOAD FROM FILE
        function loadFromFile(me,filePath)
            me.File = filePath;
            absPath = strcat(me.Application.WorkingDirectory,filesep(),me.File);
            paramsFile = strcat(me.Application.BatalefDirectory,filesep(),'user',filesep(),'tmp',filesep(),'paramsFile.mat');
            copyfile(absPath,paramsFile);
            params = load(paramsFile);
            me.Params = me.enforceCommonDefaults(params);
        end
        
        
        % SAVE TO FILE
        function saveToFile(me,filePath)
            paramsFile = strcat(me.Application.BatalefDirectory,filesep(),'user',filesep(),'tmp',filesep(),'paramsFile.mat');
            save(paramsFile,'-struct',me.Params);
            copyfile(paramsFile,filePath);
        end
        
        
        % ENFORCE COMMON PARAMETERS
        function P = enforceCommonDefaults(me,P)
            % get default common parameters
            C = me.Application.getCommonDefaults(me.Type);
            % for each param in C, put the value for it from the input User data.
            % if absent use the default from C
            F = fields(C);
            for i = 1:length(C)
                if ~isfield(P,F{i})
                    P.(F{i}) = C.(F{i});
                end
            end
        end
        
        
        % GET SINGLE VALUE /  ALL VALUES
        function val = get(me,parameterName)
            if exist('parameterName','var')
                if me.has(parameterName)
                    val = me.Params.(parameterName).value;
                else
                    err=MException('batalef:parameters:noParam',sprintf('No such parameter: %s',parameterName));
                    throwAsCaller(err);
                end
            else
                val = me.Params;
            end
        end
        
        
        % SET VALUE
        function set(me,parameterName,newValue)
            if me.has(parameterName)
                me.Params.(parameterName).value = newValue;
            else
                err=MException('batalef:parameters:noParam',sprintf('No such parameter: %s',parameterName));
                throwAsCaller(err);
            end
        end

        % CRETAE NEW PARAMETER
        function add(me,parameterName,newValue,dtype)
            if me.has(parameterName)
                err = MException('batalef:parameters:alreadyExists',sprintf('The parameter "%s" already exists and cannot be added.\nUse method "has(parameterName)" to check existance.',parameterName));
                throwAsCaller(err);
            else
                % should check value against type. for future dev
                me.Params.(parameterName).dtype = dtype;
                me.Params.(parameterName).value = newValue;
            end
        end
        
        % HAS ?
        function val = has(me,parameterName)
            val = isfield(me.Params,parameterName);
        end
        
        % GET DATA TYPE
        function dtype = getType(me,pName)
            if me.has(pName)
                dtype = me.Params.(pName).dtype;
            else
                err=MException('batalef:parameters:noParam',sprintf('No such parameter: %s',parameterName));
                throwAsCaller(err);
            end
        end
        
        % APPLICATION
        function app = get.Application(me)
            switch me.Type
                case 'application'
                    app = me.Parent;
                otherwise
                    app = me.Parent.Application;
            end
        end
                    
        
    end

    
end
