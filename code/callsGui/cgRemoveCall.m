function cgRemoveCall( allChannels )
%CGREMOVECALL -INTERNAL- Remove current displayed call
    global control;
    
    % remove call
    if allChannels
        dt = getParam('callsGUI:xWindow')/2000;
        window = control.cg.call.DetectionTime+[-dt,dt];
        channelCall.removeCalls(control.cg.k,[],window);
    else
        control.cg.call.remove();
    end
    
    % refresh display
    cgInitIndexes();
    cgShowCall(false);
    
    % refresh main gui display
    mgRefreshChannelCallsDisplay();

end

