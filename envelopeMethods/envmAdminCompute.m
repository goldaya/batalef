function [ env ] = envmAdminCompute( dataset, Fs )
%ENVMADMINCOMPUTE Compute spectrum by selected method

    global control;
    method = control.envelope.method;
    params = control.envelope.params;
    envelopeMethods;
    
    if length(m)< method
        return; % should provide error
    end
    
    methodFunc = str2func(m{method}{2});
    
    env = methodFunc(dataset, Fs, params);   
    
end