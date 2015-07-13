function [  ] = envmAdminMethodSelectedInternal( newMethod, noDialog, handleGui )
%ENVMADMINMETHODSELECTEDINTERNAL Summary of this function goes here
%   Detailed explanation goes here

    global control;
    
    
    
    %oldMethod = control.envelope.method;
    envelopeMethods;
    if length(m) < newMethod
        return; % should show error
    end
    
    if ~exist('noDialog', 'var')
        noDialog = false;
    end
    if ~exist('handleGui', 'var')
        handleGui = true;
    end
    
    [parstruct, userAbort] = defMethodsParamsDialog( m{newMethod}{3}, m{newMethod}{1}, noDialog );
    if userAbort
        return;
    end
    
    if handleGui
        handles = mgGetHandles();
        methodsui = get(handles.defMethodsEnvelopeMenu, 'Children');
        defmMethodSelected(methodsui, newMethod);
        try
            [~,menuH] = cgGetHandles('defMethodsEnvelopeMenu');
            cgmethodsui =  get(menuH, 'Children');
            defmMethodSelected(cgmethodsui, newMethod);
        catch
        end
    end
            
    control.envelope.method = newMethod;
    control.envelope.params = parstruct;
    setParam('envelope:method', newMethod);

end