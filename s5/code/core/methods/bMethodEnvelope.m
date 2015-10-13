classdef bMethodEnvelope < bMethods
    %BMETHODENVELOPE Handling envelope methods and executing them
    
    properties
    end
    
    methods
        
        % CONSTRUCTOR
        function me = bMethodEnvelope(type,paramPreamble,app,gui,withNone)
            me = me@bMethods(type,paramPreamble,'envelope',app,gui,withNone);
            me.RefreshGui = false;
        end        
        
        function [envDataset] = execute(me,dataset,Fs)
            m = me.getMethod(me.Default);
            if strcmp(m.id,'none')
                envDataset = dataset;
            else
                [~,D,P] = buildParamList(me,m);
                for i = 1:length(D)
                    params.(P{i,3}) = D{i};
                end
                methodFunc = str2func(m.func);
                envDataset = methodFunc(dataset,Fs,params);
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
        
    end
        
end

