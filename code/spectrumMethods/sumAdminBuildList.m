function [  ] = sumAdminBuildList( guifig )
%SUMADMINBUILDLIST Builds the spectrum method list

    global control;
    
    try
        handles = guidata( guifig );
        menus = handles.defMethodsSpectrumMenu;
    catch
        return;
    end    
    
    spectrumMethods;
    for i = 1:length(m)
       h = uimenu(menus, 'Label', m{i}{1},'CallBack',@sumAdminMethodSelected,'UserData',i);
       if i == control.spectrum.method
           set(h, 'Checked', 'on');
       end
    end

end

