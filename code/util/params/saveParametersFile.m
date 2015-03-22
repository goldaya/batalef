function saveParametersFile( file )
%SAVEPARAMETERSFILE Save current parameters to file

    global control;
    
    % file to save to
    if ~exist('file','var') || isempty(file)
        [filename,path] = uiputfile({'*.bpf','*.bpf Batalef Parameters File';'*.*','*.* All Files'},'Save to file',control.params.currentFile);
        if ~filename
            return;
        end
        file = strcat(path,filename);
    end
    
    control.params.currentFile = file;
    
    fid = fopen(file, 'wt');
    for i=1:length(control.params.names)
        fprintf(fid, '%s %s %f \n', ...
            control.params.names{i},...
            control.params.types{i},...
            control.params.values{i}...
            );
    end
    fclose(fid);

end

