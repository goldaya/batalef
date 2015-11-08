classdef bMethodMatching < bMethods
    %BMETHODMATCHING method handling for file calls matching
    
    properties
    end
    
    methods
        
        % CONSTRUCTOR
        function me = bMethodMatching(type,paramPreamble,app,gui,withNone)
            me = me@bMethods(type,paramPreamble,'matching',app,gui,withNone);
            me.RefreshGui = true;
        end        
        
        % EXECUTE
        function [seq,times,otherSeqs] = execute(me,fileObject,baseChannel,baseCall)
            m = me.getMethod(me.Default);
            if strcmp(m.id,'none')
                seq = [];
                times = [];
                otherSeqs = {};
            else
                [~,D,P] = me.buildParamList(m);
                for i = 1:length(D)
                    params.(P{i,3}) = D{i};
                end
                methodFunc = str2func(m.func);
                [seq,times,otherSeqs] = methodFunc(fileObject,baseChannel,baseCall,params);
                if size(seq,1) > 1
                    seq = seq';
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

