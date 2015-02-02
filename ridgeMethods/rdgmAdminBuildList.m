function [  ] = rdgmAdminBuildList(  )
%RDGMADMINBUILDLIST Builds the spectrogram method list

    global control;
    
    [~, menus] = cgGetHandles('defMethodsRidgeMenu');
    ridgeMethods;
    for i = 1:length(m)
       h = uimenu(menus, 'Label', m{i}{1},'CallBack',@rdgmAdminMethodSelected,'UserData',i);
       if i == control.ridge.method
           set(h, 'Checked', 'on');
       end
    end

end

