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
    [ paramFile ] = getParamsFileForDir( path, 'file');
    paramFile = relativepath(paramFile,control.app.WorkingDirectory);
    
    for i = 1:size(files,1)
        if iscell(files)
            audioFile = relativepath(strcat(path,files{i}),control.app.WorkingDirectory);
            control.app.addFile(audioFile,paramFile);
        else
            audioFile = relativepath(strcat(path,files),control.app.WorkingDirectory);
            control.app.addFile(audioFile,paramFile);
        end            
    end
end

