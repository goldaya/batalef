classdef bMethodBeam < bMethods
    %BMETHODNEAM method handling for file calls beam computation
    
    properties
    end
    
    methods
        
        % CONSTRUCTOR
        function me = bMethodBeam(type,paramPreamble,app,gui,withNone)
            me = me@bMethods(type,paramPreamble,'beam',app,gui,withNone);
            me.RefreshGui = true;
        end        
        
        % EXECUTE
        function [d,w,i,surface] = execute(me,batx,mics,powers,surfParams) %surfParams: zero,azRange,elRange,res
            m = me.getMethod(me.Default);
            if strcmp(m.id,'none')
                d = [];
                w = [];
                i = [];
                surface = [];
            else
                [~,D,P] = me.buildParamList(m);
                if isempty(D)
                    params = [];
                else
                    for i = 1:length(D)
                        params.(P{i,3}) = D{i};
                    end
                end
                methodFunc = str2func(m.func);
                [d,w,i,surface] = methodFunc(batx,mics,powers,params,surfParams);
            end
        end
       
        function executeGOD(me,gui)
        end
               
        % PROPOGATE TO GUI
        function propogateDefault2Gui(me,gui)
            try
                switch me.ParamPreamble
                    case 'callAnalysisFilter'
                        gui.filterChanged();
                end
            catch
            end
        end
        
    end
        
end

