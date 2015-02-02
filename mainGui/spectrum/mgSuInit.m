function mgSuInit( on )
%MGSUINIT

    global control;

    % clear both start and end lines
    mgSuClearVerticalLines();

  
    if on
        
        % start only when there is a method
        if control.spectrum.method == 0
            msgbox('Please select a method in ''Def Methods'' menu');
            return;
        end      
        
        % mark su process is on
        control.mg.su.on = true;  
        
        % set motion and click functions for axes objects
        mgAssignAxesFunctions(@mgSuStartVerticalLines,@mgSuStart);
        
    else
        
        % mark su process is on
        control.mg.su.on = false;   
        
        % set motion and click functions for axes objects
        mgAssignAxesFunctions('','');
        
    end
    

end

