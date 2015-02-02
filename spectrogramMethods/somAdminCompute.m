function [ spec ] = somAdminCompute( dataset, Fs )
%SOMADMINCOMPUTESPECTROGRAM Compute spectrum by selected method

    global control;
    method = control.spectrogram.method;
    params = control.spectrogram.params;
    spectrogramMethods;
    
    if length(m)< method
        return; % should provide error
    end
    
    methodFunc = str2func(m{method}{2});
    
    spec = methodFunc(dataset, Fs, params);   
    

end

