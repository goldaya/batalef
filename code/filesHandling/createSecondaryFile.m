function createSecondaryFile( K, dialog )
%CREATESECONDARYFILE -INTERNAL- create a secondary file and load into app

    if ~exist('dialog','var')
        dialog = true;
    end

    % ask for buffer 
    bufferParam = getParam('secondaryFiles:buffer');
    if dialog
        A = inputdlg('Buffer size around each call (msec)','Creating Secondary Files',[1,50],{num2str(bufferParam)});
        if isempty(A)
            return;
        end    
        bufferUse = str2double(A{1});
        if bufferParam ~= bufferUse
            setParam('secondaryFiles:buffer',bufferUse);
        end
    else
        bufferUse = bufferParam;
    end
    
    
    for i = 1:length(K)
        naked = fileData(K(i),'NakedName');
        ext   = fileData(K(i),'Extension');
        path  = fileData(K(i),'Path');
        
        secFile = strcat(naked,'_secondary',ext);
        secFullPath = strcat(path,secFile);
        if dialog
            [fName,path] = uiputfile(secFullPath);
            if ~fName
                continue;
            end
            secFile = fName;
            secFullPath = strcat(path,fName);
        end
        Fs = fileData(K(i),'Fs');
        fullpath = secFullPath;
        TS = createSecondaryTS( K(i), bufferUse/1000 );
        audiowrite( secFullPath, TS, Fs );
        addDataFromFile( path, secFile );
    end

end

