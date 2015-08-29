function backgroundInit( parametersFile )
%BACKGROUNDINIT initialize the batalef env for background processing

    initC();
    initB();
    backgroundLoadParams(parametersFile);
    
end

