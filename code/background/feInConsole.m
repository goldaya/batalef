function feInConsole( dirPath, parametersFile, recursive )
%FEINCONSOLE Run Feature Extraction on an export file and save

    
    fprintf('\nStarting batalef stand-alone feature extraction\n\n');
    fprintf('Root directory: %s\n',dirPath);
    fprintf('Parameters file: %s\n',parametersFile);
    if recursive
        rstr = 'true';
    else
        rstr = 'false';
    end
    fprintf('Recursive: %s\n',rstr);
    fprintf('Suppressing warning messages\n')
    w = warning;
    warning('off','all');

    
    % init batalef environment
    startTime = cputime;
    tic;
    backgroundInit(parametersFile);
    t = toc;
    fprintf('batalef system initialized in %d seconds\n',t)

    doFeDir(dirPath, recursive)
   
    
    fprintf('\nFinished!\n');
    warning(w);
    fprintf('Restored warning settings\n');
    t = cputime - startTime;
    fprintf('Total time: %d seconds\n',t);
    
end

function doFeDir(dirPath, recursive)

    global filesObject;
    
    F = dir(strcat(dirPath,filesep(),'*.mat'));
    N = length(F);
    fprintf('\nDirectory: %s\n',dirPath)
    fprintf('*.mat files in direcotry: %i\n',N)
    for i = 1:length(F)
       
        % always work on a single file - remove last file
        try
            filesObject(1) = [];
        catch err
        end
        
        % process file
        try
            fprintf('%i/%i: %s',i,N,F(i).name);
            tic;
            importFileObjectFromFile(strcat(dirPath,filesep(),F(i).name));
            K = 1:appData('Files','Count');
            fExtraction(K);
            save(strcat(dirPath,filesep(),F(i).name),'filesObject');
            t = toc;
            fprintf(': Done. %d seconds\n',t);
        catch err
            fprintf(': Error\n');
            disp(err.message);
        end
        
    end
    
    % subdirectories
    if recursive
        D = dir(dirPath);
        for i = 1:length(D)
            if D(i).isdir && ~strcmp(D(i).name,'.') && ~strcmp(D(i).name,'..')
                doFeDir(strcat(dirPath,filesep(),D(i).name),recursive);
            end
        end
    end
end