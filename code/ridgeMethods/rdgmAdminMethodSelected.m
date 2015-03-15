function [  ] = rdgmAdminMethodSelected( hObject, eventdata, handles )
%RDGMADMINMETHODSELECTED 

    newMethod = get(hObject, 'UserData');
    rdgmAdminMethodSelectedInternal( newMethod );
    
end

