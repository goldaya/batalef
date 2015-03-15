function mpgManualMark(  )
%MPGMANUALMARK Summary of this function goes here
%   Detailed explanation goes here

   
    [x,y] = ginput(1);
    mark = [x,y];
    
    % remove existing peak
    mpgRemoveMark();
    
    % add peak
    mpgAddPeak(mark);
    
    % refresh display
    mgRefreshChannelCallsDisplay( );
    mpgRefreshMark();
    
    
end

