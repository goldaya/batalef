function mgRmInit( on )
%MGRMINIT

    
    % clear both start and end lines
    mgRmClearVerticalLines();

    if on
        % mark so process is on
        control.mg.Rm.on = true;        
        % set motion and click functions for axes objects
        mgAssignAxesFunctions(@mgRmStartVerticalLines,@mgRmStart);
    else
        % mark so process is on
        control.mg.Rm.on = false;        
        % set motion and click functions for axes objects
        mgAssignAxesFunctions('','');
    end    

    
end

