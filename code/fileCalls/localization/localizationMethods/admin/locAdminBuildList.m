function [  ] = locAdminBuildList( guifig )
%SOMADMINBUILDLIST Builds the localization method list

    global control;
    
    try
        handles = guidata( guifig );
        menus = handles.dmLocMenu;
    catch
        return;
    end
    
    localizationMethods;
    for i = 1:length(m)
        h = uimenu(menus, 'Label', m{i}{1},'CallBack',@locAdminMethodSelected,'UserData',i);
        if i == control.localization.method
            set(h, 'Checked', 'on');
        end
    end

end

