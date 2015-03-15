function mgTmInit( on )
%MGTMINIT INTERNAL

    global control;
    
    % clear both start and end lines
    startLines = control.mg.tm.startVerticalLines;
    if ~isempty(startLines)
        for i = 1:length(startLines)
            if ishandle(startLines(i))
                delete(startLines(i));
            end
        end
    end
    endLines = control.mg.tm.endVerticalLines;
    if ~isempty(endLines)
        for i = 1:length(endLines)
            if ishandle(endLines(i))
                delete(endLines(i));
            end
        end
    end
    
    if on
        % mark tm process is on
        control.mg.tm.on = true;        
        % set motion and click functions for axes objects
        mgAssignAxesFunctions(@mgTmStartVerticalLines,@mgTmStart);
    else
        % mark tm process is on
        control.mg.tm.on = false;        
        % set motion and click functions for axes objects
        mgAssignAxesFunctions('','');
    end
    
end

