function [  ] = somAdminBuildList( guifig )
%SOMADMINBUILDLIST Builds the spectrogram method list

    global control;
    
    try
        handles = guidata( guifig );
        menus = handles.defMethodsSpectrogramMenu;
    catch
        return;
    end
    
    spectrogramMethods;
    for i = 1:length(m)
        h = uimenu(menus, 'Label', m{i}{1},'CallBack',@somAdminMethodSelected,'UserData',i);
        if i == control.spectrogram.method
            set(h, 'Checked', 'on');
        end
    end

end

