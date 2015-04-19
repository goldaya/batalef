function cgRemoveCall(  )
%CGREMOVECALL -INTERNAL- Remove current displayed call
    global control;
    
    % remove call
    control.cg.call.remove();
    
    % refresh display
    cgInitIndexes();
    cgShowCall();
    
    % refresh main gui display
    mgRefreshChannelCallsDisplay();

end

