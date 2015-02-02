function [  ] = sogTmInit( on )
%SOGTMINIT Summary of this function goes here
%   Detailed explanation goes here
    
    global control;
    
    
    
    
    % clear vertical lines
    handles = sogGetHandles;
    nAxes = appData('Axes','Count');
    for i=1:nAxes
        axesName = strcat('axes',num2str(i));
        axobj = handles.(axesName);
        % delete old lines
        aoc = get(axobj,'Children');
        for j = 1:length(aoc)
            if strcmp('line',get(aoc(j),'Type'))
                delete(aoc(j));
            end
        end
    end
    
    if on
        % mark tm process is on
        control.sog.tm.on = true;
        % set motion and click functions for axes objects
        sogAssignAxesFunctions(@sogTmStartVerticalLines,@sogTmStart);
    else
        % mark tm process is off
        control.sog.tm.on = false;
        % clear motion and click functions for axes objects
        sogAssignAxesFunctions('','');
    end
    
    
end

