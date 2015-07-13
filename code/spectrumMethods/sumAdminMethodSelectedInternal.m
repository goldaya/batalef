function [  ] = sumAdminMethodSelectedInternal( newMethod, noDialog, handleGui ) 
%SUMADMINMETHODSELECTED Summary of this function goes here
%   Detailed explanation goes here

    global control;
    

    
    spectrumMethods;
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
        methodsui = get(handles.defMethodsSpectrumMenu, 'Children');
        defmMethodSelected(methodsui, newMethod);
        try
            [~,menuH] = cgGetHandles('defMethodsSpectrumMenu');
            cgmethodsui =  get(menuH, 'Children');
            defmMethodSelected(cgmethodsui, newMethod);
        catch
        end
    end
        
            
    control.spectrum.method = newMethod;
    control.spectrum.params = parstruct;
    setParam('spectrum:method',newMethod);

end

