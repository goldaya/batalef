function batalefAppKill( app )
%BATALEFAPPKILL Kill batalef application

    delete(app);
    disp(' ');
    if ishandle(app)
        disp('******************************')
        disp('   ~ batalef did not die! ~')
        disp('******************************')
    else
        disp('*************************')
        disp('   ~ batalef is dead ~')
        disp('*************************')
    end
    disp(' ')

end

