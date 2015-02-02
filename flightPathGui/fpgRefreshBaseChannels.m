function fpgRefreshBaseChannels(  )
%FPGREFRESHBASECHANNELS Summary of this function goes here
%   Detailed explanation goes here

    global control;
    handles = fpgGetHandles();
    k = control.fpg.k;
    
    % get used channels
    U = fileData(k,'Mics','LocalizationUsage');
    nMicsTotal = fileData(k,'Mics','Count','NoValidation',true);
    J = 1:nMicsTotal;
    J = J(U);
    
    % init to first call in first used channel
    control.fpg.j = J(1);
    control.fpg.s = 1;
    control.fpg.a = 0;
    
    % set base channels, base calls drop-down list
    set(handles.ddBaseChannel, 'String', J);    


end

