function createSecondaryFile( K )
%CREATESECONDARYFILE -INTERNAL- create a secondary file and load into app

    for i = 1:length(K)
        naked = fileData(K(i),'NakedName');
        ext   = fileData(K(i),'Extension');
        path  = fileData(K(i),'Path');
        
        secFile = strcat(path,naked,'_secondary',ext);
        [name,path] = uiputfile(secFile);
        if name
            Fs = fileData(K(i),'Fs');
            fullpath = strcat( path, name );
            TS = createSecondaryTS( K(i) );
            audiowrite( fullpath, TS, Fs );
            addDataFromFile( path, name );
        end
    end

end

