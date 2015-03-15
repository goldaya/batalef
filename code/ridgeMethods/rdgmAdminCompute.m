function [ out ] = rdgmAdminCompute( TS, Fs )
%RDGMADMINCOMPUTESPECTROGRAM Compute spectrum by selected method

    global control;
    method = control.ridge.method;
    params = control.ridge.params;
    ridgeMethods;
    
    if length(m)< method
        return; % should provide error
    end
    
    methodFunc = str2func(m{method}{2});
    
    out = methodFunc(TS, Fs, params);
    

end

