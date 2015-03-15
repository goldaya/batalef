function mpgRemovePeaks(  )
%MPGREMOVEPEAKS Remove existing peaks that are visible on the zoom axes
%   Detailed explanation goes here
   
    global control;
    
    %{
    % get peaks to remove
    p2r = control.mpg.zoomExistingPeaks.points; % peaks to remove locations
    if isempty(p2r)
        return;
    end
    m = min(p2r);
    M = max(p2r);
    %}
    
    % remove peaks-to-remove from existing peaks
    removeChannelCalls(control.mpg.k, control.mpg.j, 'DetectionBetween', control.mpg.Ip);
    
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

