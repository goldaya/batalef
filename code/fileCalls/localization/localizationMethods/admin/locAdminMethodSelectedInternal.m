function [  ] = locAdminMethodSelectedInternal( newMethod, noDialog, handleGui )
%LOCADMINMETHODSELECTED 

    global control;
    
    
    
    localizationMethods;
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
        try
            [~,menuH] = getHandles('fcg','dmLocMenu');
            fcgmethodsui =  get(menuH, 'Children');
            defmMethodSelected(fcgmethodsui, newMethod);
        catch
        end
    end
        
    control.localization.method = newMethod;
    control.localization.params = parstruct;
    setParam('localization:method', newMethod);

end

