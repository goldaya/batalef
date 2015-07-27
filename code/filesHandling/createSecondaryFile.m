function createSecondaryFile( K, add, dialog, singleShot)
%CREATESECONDARYFILE -INTERNAL- create a secondary file and load into app

    if ~exist('dialog','var')
        dialog = true;
    end
    
    if ~exist('singleShot','var') || ~dialog
        singleShot = false;
    end

    % ask for buffer and add
    bufferParam = getParam('secondaryFiles:buffer');
    if dialog
        Q{1} = 'Buffer size around each call (msec)';
        Q{2} = 'Add to application';
        D{1} = num2str(bufferParam);
        if add
            D{2} = 'Yes';
        else
            D{2} = 'No';
        end
        A = inputdlg(Q,'Creating Secondary Files',[1,50],D);
        if isempty(A)
            return;
        end    
        bufferUse = str2double(A{1});
        if bufferParam ~= bufferUse
            setParam('secondaryFiles:buffer',bufferUse);
        end
        if singleShot
            path = uigetdir();
        end
        if strcmp(A{2},'Yes')
            add = true;
        else
            add = false;
        end
        setParam('secondaryFiles:addToApp',double(add));
    else
        bufferUse = bufferParam;
    end
    
    
    for i = 1:length(K)
        naked = fileData(K(i),'NakedName');
        ext   = fileData(K(i),'Extension');
        if ~singleShot
            path  = fileData(K(i),'Path');
        end
        
        secFile = strcat(naked,'_secondary',ext);
        secFullPath = strcat(path,filesep(),secFile);
        if dialog
            if ~singleShot
                [fName,path] = uiputfile(secFullPath);
                if ~fName
                    continue;
                end
                secFile = fName;
                secFullPath = strcat(path,filesep(),fName);
            end
        end
        Fs = fileData(K(i),'Fs');
        TS = createSecondaryTS( K(i), bufferUse/1000 );
        audiowrite( secFullPath, TS, Fs );
        if add
            addDataFromFile( path, secFile );
        end
    end

end


