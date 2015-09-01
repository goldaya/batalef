function [  ] = locAdminMethodSelected( hObject, eventdata, handles )
%LOCADMINMETHODSELECTED 

    newMethod = get(hObject, 'UserData');
    locAdminMethodSelectedInternal( newMethod );
    
end

