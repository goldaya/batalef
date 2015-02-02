function [  ] = sumAdminMethodSelected( hObject, eventdata, handles )
%SUMADMINMETHODSELECTED Summary of this function goes here
%   Detailed explanation goes here

    newMethod = get(hObject, 'UserData');
    sumAdminMethodSelectedInternal(newMethod);
    
end

