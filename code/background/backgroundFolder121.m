function backgroundFolder121( dirPath, parametersFile, recursive, outputMatrixOnly, createSecondaryFiles, secondaryParametersFile )
%BACKGROUNDFOLDER121 process all *.wav files in a directory (w/o
%subdirectories), one at a time

    fprintf('\nStarting batalef background channel calls processing\n\n');
    fprintf('Root directory: %s\n',dirPath);
    fprintf('Parameters file: %s\n',parametersFile);
    if recursive
        rstr = 'true';
    else
        rstr = 'false';
    end
    fprintf('Recursive: %s\n',rstr);
    if outputMatrixOnly
        ostr = 'Matrix';
    else
        ostr = 'batalef export file';
    end
    fprintf('Output type: %s\n',ostr);
    
    fprintf('Suppressing warning messages\n')
    w = warning;
    warning('off','all');

    
    % init batalef environment
    startTime = cputime;
    tic;
    backgroundInit(parametersFile);
    t = toc;
    fprintf('batalef system initialized in %d seconds\n',t)

    doBackgroundDir(dirPath, parametersFile, recursive, outputMatrixOnly, createSecondaryFiles, secondaryParametersFile);
    
    fprintf('\nFinished!\n');
    warning(w);
    fprintf('Restored warning settings\n');
    t = cputime - startTime;
    fprintf('Total time: %d seconds\n',t);

end

function doBackgroundDir(dirPath, parametersFile, recursive, outputMatrixOnly, createSecondaryFiles, secondaryParametersFile)

    D = dir(dirPath); % this should come before creating the secondary folder
    F1 = dir(strcat(dirPath,filesep(),'*.wav'));
    F2 = dir(strcat(dirPath,filesep(),'*.WAV'));
    F = [F1;F2];
    N = length(F);
    fprintf('\nDirectory: %s\n',dirPath)
    if createSecondaryFiles
        mkdir(strcat(dirPath,filesep(),'secondary'));
        fprintf('(created secondary folder)\n');
    end
    fprintf('*.wav files in direcotry: %i\n',N)
    for i = 1:length(F)
       
        % process file
        try
            fprintf('%i/%i - %s: ',i,N,F(i).name);
            tic;
            
            doBackgroundFile(dirPath,...
                F(i).name,...
                outputMatrixOnly,...
                createSecondaryFiles)
                
            
            t = toc;
            fprintf('\nDone. %d seconds\n',t);
        catch err
            fprintf('\nError\n');
            disp(err.message);
        end
        
    end
    
    % process secondary folder
    if createSecondaryFiles
        backgroundLoadParams(secondaryParametersFile);
        doBackgroundDir(strcat(dirPath,filesep(),'secondary'),...
            parametersFile,...
            false,...
            outputMatrixOnly,...
            false, []);
        backgroundLoadParams(parametersFile);
    end
    
    % subdirectories
    if recursive
        for i = 1:length(D)
            if D(i).isdir && ~strcmp(D(i).name,'.') && ~strcmp(D(i).name,'..')
                doBackgroundDir(strcat(dirPath,filesep(),D(i).name), ...
                    parametersFile,...
                    recursive,...
                    outputMatrixOnly,...
                    createSecondaryFiles,...
                    secondaryParametersFile);
            end
        end
    end
end

function doBackgroundFile(dirPath,fileName,outputMatrixOnly,createSecondaryFiles)

    global filesObject;
    
    % remove previous file
    try
        filesObject(1) = [];
    catch err
    end
            
    % add file to batalef
    fullpath = strcat(dirPath,filesep(),fileName);
    rawData = readRawDataFromFile(fullpath, getParam('rawData:loadWithMatrix'));
    createFileObject(1, fullpath, rawData);
    fprintf('loaded');
                
    % trim
    trimBuffer = getParam('background:trimStart')/1000;
    if trimBuffer > 0
        removeStartTS(1,trimBuffer,false);
        fprintf(', trimmed %.2f msec',trimBuffer*1000);
    end
    
    % processing
    pdBasic(1,false);
    fprintf(', detected peaks');
    fExtraction(1);
    fprintf(', extracted features');
    
    % save
    [~,naked] = fileparts(fileName);
    
    if outputMatrixOnly
        M = fileData(1,'Channels','Calls','Matrix');
        outputFile = strcat(dirPath,filesep(),naked,'_matrix.mat');
        save(outputFile,'M');
    else
        outputFile = strcat(dirPath,filesep(),naked,'_exportFile.mat');
        save(outputFile,'filesObject');
    end
    fprintf(', saved data');
    
    % secondary files
    if createSecondaryFiles
        buffer = getParam('secondaryFiles:buffer');
        Fs = fileData(1,'Fs');
        TS = createSecondaryTS( 1, buffer/1000 );
        secFullPath = strcat(dirPath,filesep(),'secondary',filesep(),naked,'_secondary.wav');
        audiowrite( secFullPath, TS, Fs );
        fprintf(', created secondary file');
    end
    
    fprintf('.');

end

