classdef bParameters < handle
    %BPARAMETERS Parameters object
    
    properties (SetAccess = ?bParameters, GetAccess = public)
        File
        Type
        Application
        Params
    end
    
    methods
        % CONSTRUCTOR
        function me = bParameters(application,type)
            switch type
                case 'file'
                case 'app'
                case 'gui'
                otherwise
                    % error
                    err = MException('batalef:parameters:objectWrongType',sprintf('Parameters-object type %s is not allowed',type));
                    throwAsCaller(err);
            end
            me.Type = type;
            me.Application = application; 
        end
        
        function doli = clone(me)
            doli = bParameters(me.Application,me.Type);
            doli.File = me.File;
            doli.Params = me.Params;
        end
        
        
        % LOAD FROM FILE
        function loadFromFile(me,filePath)
            if ~isempty(filePath)
                me.File = filePath;
            end
            absPath = strcat(me.Application.WorkingDirectory,filesep(),me.File);
            paramsFile = strcat(me.Application.BatalefDirectory,filesep(),'user',filesep(),'tmp',filesep(),'paramsFile.mat');
            copyfile(absPath,paramsFile);
            params = load(paramsFile);
            me.Params = me.enforceCommonDefaults(params);
        end
        
        
        % SAVE TO FILE
        function saveToFile(me,filePath)
            if isempty(filePath)
                filePath = me.File;
            else
                me.File = filePath;
            end            
            paramsFile = strcat(me.Application.BatalefDirectory,filesep(),'user',filesep(),'tmp',filesep(),'paramsFile.mat');
            p = me.Params; %#ok<NASGU>
            save(paramsFile,'-struct','p');
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
        
        
        
        % HAS ?
        function val = has(me,parameterName)
            val = isfield(me.Params,parameterName);
        end        
        
        % GET SINGLE VALUE /  ALL VALUES
        function val = get(me,pID)
            global batalefAlfred;
            
            if exist('pID','var') && ~isempty(pID)
                if me.has(pID)
                    val = me.Params.(pID).value;
                else
                    if batalefAlfred
                        A = inputdlg({'Value','Dtype'},pID,[1,70]);
                        if isempty(A)
                            err=MException('batalef:parameters:noParam',sprintf('No such parameter: %s',pID));
                            throwAsCaller(err);
                        else
                            val = me.str2par(A{1},A{2});
                            me.Params.(pID).value = me.str2par(A{1},A{2});
                            me.Params.(pID).dtype = A{2};                            
                        end
                    else
                        err=MException('batalef:parameters:noParam',sprintf('No such parameter: %s',pID));
                        throwAsCaller(err);
                    end
                end
            else
                val = me.Params;
            end
        end
               
        % GET DATA TYPE
        function dtype = getType(me,pID)
            if me.has(pID)
                dtype = me.Params.(pID).dtype;
            else
                err=MException('batalef:parameters:noParam',sprintf('No such parameter: %s',pID));
                throwAsCaller(err);
            end
        end        
        % SET VALUE
        function set(me,pID,newValue)
            global batalefAlfred;
            
            if me.has(pID)
                me.Params.(pID).value = newValue;
            else
                if batalefAlfred
                    A = inputdlg({'Value','Dtype'},pID,[1,70]);
                    if isempty(A)
                        err=MException('batalef:parameters:noParam',sprintf('No such parameter: %s',pID));
                        throwAsCaller(err);
                    else
                        me.Params.(pID).value = me.str2par(A{1},A{2});
                        me.Params.(pID).dtype = A{2};
                    end
                else
                    err=MException('batalef:parameters:noParam',sprintf('No such parameter: %s',pID));
                    throwAsCaller(err);
                end
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
        
        % REMOVE
        function remove(me,pID)
            if me.has(pID)
                me.Params = rmfield(me.Params,pID);
            else
                err=MException('batalef:parameters:noParam',sprintf('No such parameter: %s',pID));
                throwAsCaller(err);
            end            
        end
        
    end
    
    methods (Static = true)
        % PARAMETER TO STRING
        function str = par2str(val,dtype)
            switch dtype
                case {'double','integer','vector'}
                    str = num2str(val);
                case 'string'
                    str = val;
                case 'logical'
                    if val
                        str = 'true';
                    else
                        str = 'false';
                    end
                case 'vectorCell'
                    str = '{';
                    for i = 1:length(val)
                        if i > 1
                            str = strcat([str,' , ']);
                        end
                        str = strcat(str,'[',num2str(val{i}),']');
                    end
                    str = strcat(str,'}');
                otherwise
                    errid  = 'batalef:parameters:wrongDataType';
                    errstr = sprintf('Data type "%s" is not supported',dtype);
                    throwAsCaller(MException(errid,errstr));
            end
        end
        
        % STRING TO PARAMETER
        function val = str2par(str,dtype)
            switch dtype
                case {'double','integer'}
                    val = str2double(str);
                case 'string'
                    val = str;
                case 'vector'
                    val = str2num(str); %#ok<ST2NM>
                case 'logical'
                    val = strcmp(str,'true');
                case 'vectorCell'
                    val = eval(str);
                otherwise
                    errid  = 'batalef:parameters:wrongDataType';
                    errstr = sprintf('Data type "%s" is not supported',dtype);
                    throwAsCaller(MException(errid,errstr));
            end
        end
    end

    
end
