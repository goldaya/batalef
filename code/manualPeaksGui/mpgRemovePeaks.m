function mpgRemovePeaks(  )
%MPGREMOVEPEAKS Remove existing peaks that are visible on the zoom axes
%   Detailed explanation goes here
   
    global control;
    
    % remove peaks-to-remove from existing peaks
    channelCall.removeCalls(control.mpg.k, control.mpg.j, control.mpg.It);
    
    % refresh peaks on display
    mgRefreshChannelCallsDisplay( );
    if isfield(control.mpg,'hExisting') && ~isempty(control.mpg.hExisting) && ishandle(control.mpg.hExisting)
        delete(control.mpg.hExisting);
        control.mpg.hExisting = [];
    end
    if isfield(control.mpg,'hMark') && ~isempty(control.mpg.hMark) && ishandle(control.mpg.hMark)
        delete(control.mpg.hMark);
        control.mpg.hMark = [];
    end
    
end

