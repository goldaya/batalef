classdef bMethodLocalization < bMethods
    %BMETHODLOCALIZATION method handling for file calls localization
    
    properties
    end
    
    methods
        
        % CONSTRUCTOR
        function me = bMethodLocalization(type,paramPreamble,app,gui,withNone)
            me = me@bMethods(type,paramPreamble,'filter',app,gui,withNone);
            me.RefreshGui = true;
        end        
        
        % EXECUTE
        function [location,time] = execute(me,startTimes,MicPositions,extParams)
            m = me.getMethod(me.Default);
            if strcmp(m.id,'none')
                location = [];
                time = [];
            else
                [~,D,P] = me.buildParamList(m);
                for i = 1:length(D)
                    params.(P{i,3}) = D{i};
                end
                methodFunc = str2func(m.func);
                [location,time] = ...
                    methodFunc(startTimes,MicPositions,params,extParams);
            end
        end
       
        function executeGOD(me,gui)
            P = gui.ProcessVector;
            Files = me.Application.Files(P);
            cellfun(@(f) me.augustinus(f),Files,'UniformOutput',false);
            if me.RefreshGui
                gui.refresh();
            end            
        end
        
        function augustinus(me,File)
            fTS = me.execute(File.RawData.getTS([],[]),File.RawData.Fs);
            File.RawData.alter(fTS,{'Filter',NaN});
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

