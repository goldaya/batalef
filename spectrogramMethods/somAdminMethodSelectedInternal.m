function [  ] = somAdminMethodSelectedInternal( newMethod, noDialog )
%SOMADMINMETHODSELECTED 

    global control;
    handles = mgGetHandles();
    
    
    spectrogramMethods;
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
    
    methodsui = get(handles.defMethodsSpectrogramMenu, 'Children');
    defmMethodSelected(methodsui, newMethod);
    try
        [~,menuH] = cgGetHandles('defMethodsSpectrogramMenu');
        cgmethodsui =  get(menuH, 'Children');
        defmMethodSelected(cgmethodsui, newMethod);
    catch
    end
    
        
    control.spectrogram.method = newMethod;
    control.spectrogram.params = parstruct;
    setParam('spectrogram:method', newMethod);

end

