function [  ] = somAdminMethodSelected( hObject, eventdata, handles )
%SOMADMINMETHODSELECTED 

    newMethod = get(hObject, 'UserData');
    somAdminMethodSelectedInternal( newMethod );
    
end

