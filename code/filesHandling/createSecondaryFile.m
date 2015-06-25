function createSecondaryFile( K )
%CREATESECONDARYFILE -INTERNAL- create a secondary file and load into app

    % ask for buffer 
    bufferParam = getParam('secondaryFiles:buffer');
    A = inputdlg('Buffer size around each call (msec)','Creating Secondary Files',[1,50],{num2str(bufferParam)});
    if isempty(A)
        return;
    end
    
    bufferUse = str2double(A{1});
    if bufferParam ~= bufferUse
        setParam('secondaryFiles:buffer',bufferUse);
    end
    
    
    for i = 1:length(K)
        naked = fileData(K(i),'NakedName');
        ext   = fileData(K(i),'Extension');
        path  = fileData(K(i),'Path');
        
        secFile = strcat(path,naked,'_secondary',ext);
        [name,path] = uiputfile(secFile);
        if name
            Fs = fileData(K(i),'Fs');
            fullpath = strcat( path, name );
            TS = createSecondaryTS( K(i), bufferUse/1000 );
            audiowrite( fullpath, TS, Fs );
            addDataFromFile( path, name );
        end
    end

end

