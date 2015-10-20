classdef bMethodFilter < bMethods
    %BMETHODFILTER method handling for filter definition and execution
    
    properties
    end
    
    methods
        
        % CONSTRUCTOR
        function me = bMethodFilter(type,paramPreamble,app,gui,withNone)
            me = me@bMethods(type,paramPreamble,'filter',app,gui,withNone);
            me.RefreshGui = true;
        end        
        
        % EXECUTE
        function [filteredDataset,filterApplied,filterObject] = execute(me,dataset,Fs)
            m = me.getMethod(me.Default);
            if strcmp(m.id,'none')
                filteredDataset = dataset;
                filterApplied   = true;
                filterObject    = [];
            else
                [~,D,P] = me.buildParamList(me,m);
                for i = 1:length(D)
                    params.(P{i,3}) = D{i};
                end
                methodFunc = str2func(m.func);
                [filteredDataset,filterApplied,filterObject] = ...
                    methodFunc(dataset,Fs,params);
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

