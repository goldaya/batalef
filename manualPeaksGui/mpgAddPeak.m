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
    
    Fs = fileData(control.mpg.k,'Fs');
    addChannelCalls(control.mpg.k, control.mpg.j,[round(point(1).*Fs), point(2)]);
    control.mpg.mark = point;
    mgRefreshChannelCallsDisplay( );
    

end

