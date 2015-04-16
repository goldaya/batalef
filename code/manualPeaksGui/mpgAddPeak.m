function [  ] = mpgAddPeak( point )
%PDGADDZOOMPEAK Summary of this function goes here
%   Detailed explanation goes here

    global control;
   
    % do only when there is a peak to add
    if isempty(point) 
        return; 
    end
    
    % remove existing mark
    mpgRemoveMark();
    
    channelCall.addCalls(control.mpg.k, control.mpg.j, point);
    control.mpg.mark = point;
    mgRefreshChannelCallsDisplay( );
    

end

