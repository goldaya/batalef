function backgroundLoadParams( parametersFile )
%BACKGROUNDLOADPARAMS load parameters file in background processing
    
    global control;
    
    cFile = dir(parametersFile);
    if isempty(cFile)
        err = MException('batalef:backgroundRun:noParametersFile','No parameters file');
        throw(err);
    else
        loadParametersFile( parametersFile );
    end
    envmAdminMethodSelectedInternal(control.envelope.method, true, false);
    somAdminMethodSelectedInternal(control.spectrogram.method, true, false);
    sumAdminMethodSelectedInternal(control.spectrum.method, true, false);    

end

