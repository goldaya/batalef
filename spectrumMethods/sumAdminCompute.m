function [ spec ] = sumAdminCompute( TS, Fs )
%SUMADMINCOMPUTE Compute spectrum by selected method

    global control;
    method = control.spectrum.method;
    params = control.spectrum.params;
    spectrumMethods;
    
    if length(m)< method
        return; % should provide error
    end
    
    methodFunc = str2func(m{method}{2});
    
    spec = methodFunc(TS, Fs, params);   
    

end

