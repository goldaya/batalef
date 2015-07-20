classdef bParam < handle
    %BPARAM Parameters object
    
    properties
        file
        application
        type
        parent % application / file / gui object
    end
    
    properties (SetAccess = protected)
        names
        types
        values
    end
  
    methods
        % CONSTRUCTOR
        function me = bparam(application,type,parent)
            switch type
                case 'file'
                case 'application'
                case 'gui'
                otherwise
                    % error
                    err = MException('batalef:parameters:objectWrongType',sprintf('Parameters-object type %s is not allowed',type));
                    throw(err);
            end
            me.type = type;
            me.application = application; % application control class
            me.parent = parent;
        end
        
        
        % LOAD FROM FILE
        function loadFromFile(me,filePath)
            me.file = filePath;
            fid = fopen(filePath);
            A = textscan(fid, '%s %s %f'); % name, type, value(float)
            fclose(fid);
            A{3} = num2cell(A{3});
            A = me.enforceCommonDefaults(A);
            me.names  = A{1};
            me.types  = A{2};
            me.values = A{3};            
        end
        
        
        % SAVE TO FILE
        function saveToFile(me,filePath)
            fid = fopen(filePath, 'wt');
            for i=1:length(me.names)
                fprintf(fid, '%s %s %f \n', ...
                    me.names{i},...
                    me.types{i},...
                    me.values{i}...
                    );
            end
            fclose(fid);            
        end
        
        
        % ENFORCE COMMON PARAMETERS
        function paramsOut = enforceCommonDefaults(me,paramsIn)
            % get default common parameters
            C = me.application.getCommonDefaults(me.type);
            
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
                val = me.values{idx};
            else
                val = cell(3,1);
                val{1} = me.names;
                val{2} = me.types;
                val{3} = me.values;
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
            me.values{idx} = newValue;
        end
        
        
        % FIND INDEX
        function idx = findIdx(me,parameterName)
            idx = find(strcmp(parameterName,me.names));
            if isempty(idx)
                err = MException('batalef:parameters:noParameter',sprintf('No parameter with name "%s"',parameterName));
                throw(err);
            elseif length(idx) > 1
                err = MException('batalef:parameters:doubleParameter',sprintf('The parameter "%s" has more than one instance',parameterName));
                throw(err)
            end
        end
        
    end

    
end