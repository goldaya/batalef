function [  ] = mgKill(  )
%MGKILL Destroy main gui and all other open guis

    global control;

    cgKill();
    sugKill();
    sogKill();
    mpgKill();
    fpgKill();
    pwpdgKill();
    mcgKill();
    
    
    if ~isempty(control.mg.fig) 
        if ishandle(control.mg.fig)
            delete(control.mg.fig);
        end
        control.mg.fig = [];
    end
    
    % clean up
    global filesObject;
    global c;
    clearvars -global filesObject;
    clearvars -global control;
    clearvars -global c;
    
        

end

