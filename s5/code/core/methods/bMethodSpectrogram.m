classdef bMethodSpectrogram < bMethods
    %BMETHODSPECTROGRAM default method handling for spectrogram computation
    
    properties
    end
    
    methods
        
        % CONSTRUCTOR
        function me = bMethodSpectrogram(type,paramPreamble,app,gui)
            me = me@bMethods(type,paramPreamble,'spectrogram',app,gui);
        end        
        
        function spec = execute(me,dataset,Fs)
            m = me.getMethod(me.Default);
            [~,D,P] = buildParamList(me,m);
            for i = 1:length(D)
                params.(P{i,3}) = D{i};
            end
            methodFunc = str2func(m.func);
            spec = methodFunc(dataset, Fs, params);
         end
        
    end
    
end

