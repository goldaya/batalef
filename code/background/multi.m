function multi(audiopath, mainConfigFile, createSecondaryFiles, secondaryConfigFile, outputOnlyMatrix)
        
    D = dir(audiopath); % top level directories
    for i = 1:length(D)
        if strcmp(D(i).name,'.')
            % nothing
        elseif strcmp(D(i).name,'..')
            % nothing
        elseif D(i).isdir
            currFolder = strcat(audiopath,filesep(),D(i).name);
            F = dir(currFolder);
            j = 0;
            doNewDir = true;
            
            for k= 1:length(F) % looping through files
                if strcmp(F(k).name,'.') || strcmp(F(k).name,'..') || F(k).isdir
                    continue;
                end
                
                if doNewDir
                    j = j+1;
                    batchFolder = strcat(currFolder,filesep(),D(i).name,'_batch_',num2str(j));
                    mkdir(batchFolder);
                    doNewDir = false;
                end
                % move file to batch folder
                currFile = strcat(currFolder,filesep(),F(k).name);
                newFile = strcat(batchFolder,filesep(),F(k).name);
                movefile(currFile,newFile);
                
                %after 100 files, run script
                if k == length(F) || mod(k,100) == 0
                    backgroundFolder(...
                        batchFolder,...
                        strcat(D(i).name,'_batch_',num2str(j)),...
                        mainConfigFile,...
                        createSecondaryFiles,...
                        secondaryConfigFile,...
                        outputOnlyMatrix);
                    
                    doNewDir = true;
                    
                end
            end
        else
            % nothing
        end
    end
end