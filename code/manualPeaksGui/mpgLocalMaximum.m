function mpgLocalMaximum(  )
%MPGLOCALMAXIMUM Summary of this function goes here
%   Detailed explanation goes here
    
    global control;
    
    % do only when there is a peak to add
    if ~isfield(control.mpg, 'zoomPeak')
        return;
    elseif isempty(control.mpg.zoomPeak)
        return;
    end        
    
    % delete existing mark
    mpgRemoveMark();
    
    % add the local maximum as detection point
    mpgAddPeak(control.mpg.zoomPeak);
    
    % refresh display
    mpgRefreshMark();
    
end

