classdef bMethodSpectrum < bMethods
    %BMETHODSPECTROGRAM default method handling for spectrum computation
    
    properties
    end
    
    methods
        
        % CONSTRUCTOR
        function me = bMethodSpectrum(type,paramPreamble,app,gui,withNone)
            me = me@bMethods(type,paramPreamble,'spectrum',app,gui,withNone);
        end        
        
        function spec = execute(me,dataset,Fs)
            m = me.getMethod(me.Default);
            [~,D,P] = buildParamList(me,m);
            params = struct([]);
            for i = 1:length(D)
                params(1).(P{i,3}) = D{i};
            end
            methodFunc = str2func(m.func);
            spec = methodFunc(dataset, Fs, params);
         end
        
    end
    
end

