function [  ] = envmAdminBuildList( guifig )
%ENVMADMINBUILDLIST Builds the spectrum method list

    global control;

    try
        handles = guidata( guifig );
        menus = handles.defMethodsEnvelopeMenu;
    catch
        return;
    end    
    
    envelopeMethods;
    for i = 1:length(m)
       h = uimenu(menus, 'Label', m{i}{1},'CallBack',@envmAdminMethodSelected,'UserData',i);
       if i == control.envelope.method
           set(h, 'Checked', 'on');
       end
    end

end

