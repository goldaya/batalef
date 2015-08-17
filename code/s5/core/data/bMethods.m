classdef bMethods < handle
    
    properties (Access = private)
        ParamPreamble
        Methods
        Idx = 1
    end
    
    methods
        
        function me = bMethods()
        end
        
        function val = exists(me, title)
            val = max(strcmp(title,{me.Methods(:).title}));
        end
        
        function register(me, title, func, params)
            % check first func is accessible
            if isempty(which(func))
                errstr = sprintf('The function %s is inaccessible',func);
                err = MException('batalef:defaultMethods:functionInaccessible',errstr);
                throw(err);
            end
               
            % check method is already registered
            if me.exists(title)
                return;
            end
            
            % add
            n = length(me.Methods) + 1;
            me.Methods(n).title  = title;
            me.Methods(n).func   = func;
            me.Methods(n).params = params; 
        end
        
        function createMenu(me,menu)
        end

        function askParamsGui(me)
        end
        
        function out = execute(me,varargin)
            func = str2func(me.Methods(me.Idx).func);
            out = func(varargin{:});
        end
    end
end

