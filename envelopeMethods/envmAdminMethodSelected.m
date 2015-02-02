function [  ] = envmAdminMethodSelected( hObject, eventdata, handles )
%ENVMADMINMETHODSELECTED Summary of this function goes here
%   Detailed explanation goes here
    
    newMethod = get(hObject, 'UserData');
    envmAdminMethodSelectedInternal( newMethod );
    
end

