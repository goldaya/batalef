function [  ] = bmAdminMethodSelected( hObject, eventdata, handles )
%BMADMINMETHODSELECTED Summary of this function goes here
%   Detailed explanation goes here
    
    newMethod = get(hObject, 'UserData');
    bmAdminMethodSelectedInternal( newMethod );
    
end

