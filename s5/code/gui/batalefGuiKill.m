function batalefGuiKill( guiTop )
%BATALEFGUIKILL Kill all guis + terminate application

    A = questdlg(sprintf('Any unsaved data will be lost.\nAre you sure you want to exit?'),'Exit batalef','Yes','No','No');
    if strcmp(A,'Yes')
        app = guiTop.Application;
        delete(guiTop);
        batalefAppKill(app);
    end
end

