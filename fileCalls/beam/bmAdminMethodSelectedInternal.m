function [  ] = bmAdminMethodSelectedInternal( newMethod, noDialog )
%BMADMINMETHODSELECTEDINTERNAL

    global control;
    handles = fpgGetHandles();
    
    
    %oldMethod = control.envelope.method;
    beamMethods;
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
    
    
    methodsui = get(handles.defMethodsBeamMenu, 'Children');
    defmMethodSelected(methodsui, newMethod);
            
    control.beam.method = newMethod;
    control.beam.params = parstruct;
    setParam('beam:method', newMethod);

end

