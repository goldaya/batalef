function [  ] = rdgmAdminMethodSelectedInternal( newMethod, noDialog )
%RDGMADMINMETHODSELECTED 

    global control;
    handles = cgGetHandles();
    
    
    ridgeMethods;
    if length(m) < newMethod
        return; % should show error
    end
    
    if ~exist('noDialog', 'var')
        noDialog = false;
    end    
    [parstruct, userAbort] = defMethodsParamsDialog( m{newMethod}{3}, m{newMethod}{1}, noDialog );
    if userAbort
        return;
    end
    
    methodsui = get(handles.defMethodsRidgeMenu, 'Children');
    n = length(methodsui);
    for i = 1:n
        if get(methodsui(i),'UserData')==newMethod
            set(methodsui(i), 'Checked', 'on')
        else
            set(methodsui(i), 'Checked', 'off')
        end
    end
        
    control.ridge.method = newMethod;
    control.ridge.params = parstruct;
    setParam('ridge:method', newMethod);

end

