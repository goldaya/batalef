function mgSoInit( on )
%MGSOINIT INTERNAL

    global control;

    % clear both start and end lines
    mgSoClearVerticalLines();
    
    if on
        % mark so process is on
        control.mg.so.on = true;        
        % set motion and click functions for axes objects
        mgAssignAxesFunctions(@mgSoStartVerticalLines,@mgSoStart);
    else
        % mark so process is on
        control.mg.so.on = false;        
        % set motion and click functions for axes objects
        mgAssignAxesFunctions('','');
    end

end

