function [  ] = envmAdminMethodSelectedInternal( newMethod, noDialog )
%ENVMADMINMETHODSELECTEDINTERNAL Summary of this function goes here
%   Detailed explanation goes here

    global control;
    handles = mgGetHandles();
    
    
    %oldMethod = control.envelope.method;
    envelopeMethods;
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
    
    
    methodsui = get(handles.defMethodsEnvelopeMenu, 'Children');
    defmMethodSelected(methodsui, newMethod);
    try
        [~,menuH] = cgGetHandles('defMethodsEnvelopeMenu');
        cgmethodsui =  get(menuH, 'Children');
        defmMethodSelected(cgmethodsui, newMethod);
    catch
    end
            
    control.envelope.method = newMethod;
    control.envelope.params = parstruct;
    setParam('envelope:method', newMethod);

end

