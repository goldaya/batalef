classdef bMethodLocalization < bMethods
    %BMETHODLOCALIZATION method handling for file calls localization
    
    properties
    end
    
    methods
        
        % CONSTRUCTOR
        function me = bMethodLocalization(type,paramPreamble,app,gui,withNone)
            me = me@bMethods(type,paramPreamble,'localization',app,gui,withNone);
            me.RefreshGui = true;
        end        
        
        % EXECUTE
        function [location] = execute(me,dT,MicPositions,sonic,extParams)
            m = me.getMethod(me.Default);
            if strcmp(m.id,'none')
                location = [];
            else
                params = struct();
                [~,D,P] = me.buildParamList(m);
                for i = 1:length(D)
                    params.(P{i,3}) = D{i};
                end
                methodFunc = str2func(m.func);
                [location] = ...
                    methodFunc(dT,MicPositions,sonic,params,extParams);
                if size(location,2) < 3
                    location = location';
                end
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

