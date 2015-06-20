function addDataFromFile( path, filename )
%ADDDATAFROMFILE Get data from a specific file and add to dataObject

    global control c filesObject;
    
    % check if file already exist
    n = appData('Files','Index',strcat(path,filename));
    if n > 0
        switch control.overwriteFile
            case c.never
                return;
            case c.always
            case c.ask
                control.overwriteFile = askFileOverwrite(path,filename);
                switch control.overwriteFile
                    case c.never
                        return;
                    case c.no
                        control.overwriteFile = c.ask;
                        return;
                    case c.yes
                        control.overwriteFile = c.ask;
                    case c.always
                end
        end
    else
        n = length(filesObject) + 1 ;
    end
    
    fullpath = strcat( path, filename );
    rawData = readRawDataFromFile(fullpath,getParam('rawData:loadWithMatrix'));
    createFileObject( n, fullpath, rawData );
    
end

