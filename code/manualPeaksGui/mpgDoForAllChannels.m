function mpgDoForAllChannels()
%MPGDOFORALLCHANNELS - INTERNAL - Mark calls in all channels based on
%current window

    global control;
    k = control.mg.k; %appData('Files','Displayed');
    J = fileData(k,'Channels','Count');
    Fs = fileData(k,'Fs');
    
    % determine points interval
    It = control.mpg.It;
    Ip = round(It.*Fs);
    
    % do for each channel
    for j = 1:J
   
        % get existing calls - do only when there is no existing call
        if isempty(channelData( k, j, 'Calls', 'Detections', It ))
            
            % get envelope
            [wenv] = channelData( k, j, 'Envelope', Ip );
            
            % get local peak for channel j
            [V,L] = max(wenv); % get highest peak
            t = It(1) + L(1)/Fs;
                        
            % add to calls list
            channelCall.addCalls(control.mpg.k, j,[t, V(1)]);
            
        end % end if
        
    end % end loop
    
    msgbox('Finished');
    mgRefreshChannelCallsDisplay( );

end

