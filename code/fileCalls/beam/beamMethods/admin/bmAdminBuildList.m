function [  ] = bmAdminBuildList( guifig )
%BMADMINBUILDLIST Builds the beam method list

    global control;

    try
        handles = guidata( guifig );
        menus = handles.dmBeamMenu;
    catch
        return;
    end    
    
    beamMethods;
    for i = 1:length(m)
       h = uimenu(menus, 'Label', m{i}{1},'CallBack',@bmAdminMethodSelected,'UserData',i);
       if i == control.beam.method
           set(h, 'Checked', 'on');
       end
    end

end

