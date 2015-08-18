function feInConsole2( dirPath, parametersFiles, recursive )
%FEINCONSOLE Run Feature Extraction on an export file and save

    
    fprintf('\nStarting batalef stand-alone feature extraction\n\n');
    fprintf('Root directory: %s\n',dirPath);
    if recursive
        rstr = 'true';
    else
        rstr = 'false';
    end
    fprintf('Recursive: %s\n',rstr);
    fprintf('Suppressing warning messages\n')
    w = warning;
    warning('off','all');

    if ischar(parametersFiles)
        parstmp = {1,parametersFiles};
        parametersFiles = parstmp;
    end
    
    % init batalef environment
    startTime = cputime;
    tic;
    backgroundInit('common/default.bpf');
    t = toc;
    fprintf('batalef system initialized in %d seconds\n',t)

    doFeDir(dirPath, parametersFiles, recursive)
    
    fprintf('\nFinished!\n');
    warning(w);
    fprintf('Restored warning settings\n');
    t = cputime - startTime;
    fprintf('Total time: %d seconds\n',t);
    
end

function doFeDir(dirPath, parametersFiles, recursive)

    global filesObject;
    
    F = dir(strcat(dirPath,filesep(),'*.mat'));
    N = length(F);
    fprintf('\nDirectory: %s\n',dirPath)
    fprintf('*.mat files in direcotry: %i\n',N)

    for i = 1:length(F)
       
        % always work on a single file - remove last file
        try
            filesObject(1:k) = [];
        catch err
        end
        
        % process file
        try
            fprintf('%i/%i: %s\n',i,N,F(i).name);
            tic;
            importFileObjectFromFile(strcat(dirPath,filesep(),F(i).name));
            if size(filesObject,2) > size(filesObject,1)
                filesObject = filesObject';
            end
            k = appData('Files','Count');
            fprintf('Audio files assigned: %i\n',k);
            fromFile = 0;
            toFile = 0;
            for p=1:size(parametersFiles,1)
                if toFile == k
                    break;
                else
		    fromFile = toFile+1;
		end
                if size(parametersFiles,1) > p
                    toFile = min(parametersFiles{p+1,1}-1,k);
                else
                    toFile = k;
                end
                parametersFile = parametersFiles{p,2};
                fprintf('Parameters file: %s',parametersFile);
                backgroundLoadParams(parametersFile);
                fprintf(' - loaded\nProcessing %i to %i\n',fromFile,toFile);
                K = fromFile:toFile;
                fExtraction(K);
            end
            fca = cell(k,1);
            for j = 1:k
                fca{j} = filesObject(j);
            end
            save(strcat(dirPath,filesep(),F(i).name),'fca');
            t = toc;
            fprintf('Done. %d seconds\n',t);
        catch err
            fprintf(': Error\n');
            disp(err.message);
        end
        
    end
    
    % subdirectories
    if recursive
        try
            filesObject(1:k) = [];
        catch err
        end

        D = dir(dirPath);
        for i = 1:length(D)
            if D(i).isdir && ~strcmp(D(i).name,'.') && ~strcmp(D(i).name,'..')
                doFeDir(strcat(dirPath,filesep(),D(i).name),parametersFiles,recursive);
            end
        end
    end
end
