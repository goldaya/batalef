function mpgDoForAllChannels()
%MPGDOFORALLCHANNELS - INTERNAL - Mark calls in all channels based on
%current window

    global control;
    k = control.mg.k;%appData('Files','Displayed');
    J = fileData(k,'Channels','Count');
    Fs = fileData(k,'Fs');
    nSamples = fileData(k,'nSamples');
    
    % determine points interval
    It = control.mpg.tc + control.mpg.window.time.*[-1/2,1/2]./1000;
    Ip = round(It.*Fs);
    if Ip(1) < 1
        Ip(1) = 1;
    end
    if Ip(2) > nSamples
        Ip(2) = nSamples;
    end
    
    % do for each channel
    for j = 1:J
   
        % get existing calls - do only when there is no existing call
        peaksPoints = channelData( k, j, 'Calls', 'Detections' );
        if isempty(peaksPoints) || max(peaksPoints >= Ip(1) & peaksPoints <= Ip(2)) == false
            
            % get envelope
            [wenv] = channelData( k, j, 'Envelope', Ip );
            
            % get local peak for channel j
            [V,L] = max(wenv); % get highest peak
                        
            % add to calls list
            addChannelCalls(control.mpg.k, j,[(Ip(1)+L(1)), V(1)]);
            
        end % end if
        
    end % end loop
    
    msgbox('Finished');
    mgRefreshChannelCallsDisplay( );

end

