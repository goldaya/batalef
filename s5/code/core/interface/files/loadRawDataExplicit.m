function loadRawDataExplicit( files, position )
%LOADRAWDATAEXPLICIT load raw data into internal/extermal position for
%several files

    global control;
    N  = length(files);
    Files = control.app.Files(files);
    if appData('ParProc','Allowed')
        parfor i = 1:N
            tentacleAttack(Files{i},position);
        end
    else
        for i = 1:N
            tentacleAttack(Files{i},position);
        end        
    end
    

end

function tentacleAttack(File,position)
    switch position
        case 'internal'
            File.RawData.loadExplicit();
        case 'external'
            File.RawData.unloadExplicit();    
    end
end

