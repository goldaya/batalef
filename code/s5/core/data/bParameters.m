classdef bParameters < handle
    %BPARAMETERS Parameters object
    
    properties
        File
        Type
        Parent % application / file / gui object
    end
    
    properties (SetAccess = private)
        Names
        Types
        Values
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
            fid = fopen(me.Application.physpath(filePath));
            A = textscan(fid, '%s %s %f'); % name, type, value(float)
            fclose(fid);
            A{3} = num2cell(A{3});
            A = me.enforceCommonDefaults(A);
            me.Names  = A{1};
            me.Types  = A{2};
            me.Values = A{3};            
        end
        
        
        % SAVE TO FILE
        function saveToFile(me,filePath)
            fid = fopen(filePath, 'wt');
            for i=1:length(me.Names)
                fprintf(fid, '%s %s %f \n', ...
                    me.Names{i},...
                    me.Types{i},...
                    me.Values{i}...
                    );
            end
            fclose(fid);            
        end
        
        
        % ENFORCE COMMON PARAMETERS
        function paramsOut = enforceCommonDefaults(me,paramsIn)
            % get default common parameters
            C = me.Application.getCommonDefaults(me.Type);
            
            % for each param in C, put the value for it from the input User data.
            % if absent use the default from C
            paramsOut{1} = cell(0,1);
            paramsOut{2} = cell(0,1);
            paramsOut{3} = cell(0,1);
            for i = 1:size(C{1},1)
                j = find(strcmp(C{1}{i},paramsIn{1}));
                if isempty(j)
                    paramsOut{1}{i,1} = C{1}{i};
                    paramsOut{2}{i,1} = C{2}{i};
                    paramsOut{3}{i,1} = C{3}{i};
                else
                    paramsOut{1}{i,1} = paramsIn{1}{j};
                    paramsOut{2}{i,1} = paramsIn{2}{j};
                    paramsOut{3}{i,1} = paramsIn{3}{j};            
                end
            end
        end
        
        
        % GET SINGLE VALUE /  ALL VALUES
        function val = get(me,parameterName)
            if exist('parameterName','var')
                idx = me.findIdx(parameterName);
                val = me.Values{idx};
            else
                val = cell(3,1);
                val{1} = me.Names;
                val{2} = me.Types;
                val{3} = me.Values;
            end
        end
        
        
        % SET VALUE
        function set(me,parameterName,newValue)
            idx = me.findIdx(parameterName);
            %currently only numeral scalars allowed
            if ~isscalar(newValue)
                err = MException('batalef:parameters:nonScalarValue',sprintf('Value for parameters must be scalar. Parameter: "%s"',parameterName));
                throw(err);
            end
            me.Values{idx} = newValue;
        end
        
        
        % FIND INDEX
        function idx = findIdx(me,parameterName)
            idx = find(strcmp(parameterName,me.Names));
            if isempty(idx)
                err = MException('batalef:parameters:noParameter',sprintf('No parameter with name "%s"',parameterName));
                throw(err);
            elseif length(idx) > 1
                err = MException('batalef:parameters:doubleParameter',sprintf('The parameter "%s" has more than one instance',parameterName));
                throw(err)
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
