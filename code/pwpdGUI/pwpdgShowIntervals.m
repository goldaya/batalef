function [  ] = pwpdgShowIntervals( show )
%PWPDGSHOWINTERVALS Summary of this function goes here
%   Detailed explanation goes here

    global control;
    
    
    % get intervals
    k = appData('Files','Displayed');
    if show
        control.pwpdIntervals = pwpdgSetIntervals(k);
    else
        control.pwpdIntervals = [];
    end
    mgRefreshAxes();
    
end

