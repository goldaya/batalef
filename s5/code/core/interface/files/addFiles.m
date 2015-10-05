function addFiles( path,files )
%ADDFILES Add files to application (this is cli/gui function, not purely
%interface)

    global control;

    if isempty(path)
        [files,path] = uigetfile({'*.wav';'*.WAV'},'MultiSelect','on');
        if path == 0
            % user abort
            return;
        end
    elseif isempty(files)
            F = dir(strcat(path,filesep(),'*.wav'));
            files = {F.name};
    end            
    
    % ask for parameter files
    if control.app.FilesSingleParamsFile && control.app.FilesCount > 0
        paramFile = [];
    else
        [ paramFile ] = getParamsFileForDir(path,'file');
        paramFile = relativepath(paramFile,control.app.WorkingDirectory);
    end
    
    if iscell(files)
        for i = 1:length(files)
            audioFile = relativepath(strcat(path,files{i}),control.app.WorkingDirectory);
            control.app.addFile(audioFile,paramFile);
        end
    else
        audioFile = relativepath(strcat(path,files),control.app.WorkingDirectory);
        control.app.addFile(audioFile,paramFile);          
    end
end

