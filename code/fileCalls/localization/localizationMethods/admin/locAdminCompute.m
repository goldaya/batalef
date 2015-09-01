function [ x,t ] = locAdminCompute( channelCallsTimes, MicPositions )
%LOCADMINCOMPUTESPECTROGRAM Compute localization by selected method

    global control;
    method = control.localization.method;
    params = control.localization.params;
    localizationMethods;
    
    if length(m)< method
        msgbox('error');
        return; % should provide error
    end
    
    methodFunc = str2func(m{method}{2});
    
    [x,t] = methodFunc(channelCallsTimes, MicPositions, params);   
    

end

