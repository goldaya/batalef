classdef bMethodRidge < bMethods
    %BMETHODRIDGE methods for finding channel call's ridge
    
    properties
    end
    
    methods
        
        % CONSTRUCTOR
        function me = bMethodRidge(type,paramPreamble,app,gui,withNone)
            me = me@bMethods(type,paramPreamble,'ridge',app,gui,withNone);
            me.RefreshGui = false;
        end        
        
        function [ridge] = execute(me,call)
            m = me.getMethod(me.Default);
            if strcmp(m.id,'none')
                ridge = zeros(0,3);
            else
                [~,D,P] = buildParamList(me,m);
                for i = 1:length(D)
                    params.(P{i,3}) = D{i};
                end
                
                extParams.callStartTime = call.Start.Time;
                extParams.callPeakTime  = call.Peak.Time;
                extParams.callEndTime   = call.End.Time;
                spec = call.AnalysisParameters.spectrogram;
                TS.dataset = call.AnalysisParameters.TS;
                TS.Fs = call.Fs;
                TS.offset = call.AnalysisParameters.offset;
                
                methodFunc = str2func(m.func);
                ridge = methodFunc(spec,TS,params,extParams);
            end
        end
       
        function executeGOD(me,gui) %#ok<INUSD>
        end
        
    end
        
end

