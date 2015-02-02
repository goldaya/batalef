function loadParametersFile( file )
%LOADSETTINGSFILE Load parameters from a parameters file (.bpf)

    global control;
    
    if ~exist('file','var') || isempty(file)
        [filename,path] = uigetfile({'*.bpf','*.bpf Batalef Parameters File';'*.*','*.* All Files'},'Load from file', control.params.currentFile);
        if ~filename
            return;
        end
        file = strcat(path,filename);
    end    
    
    fid = fopen(file);
    A = textscan(fid, '%s %s %f'); % name, type, value(float)
    fclose(fid);
    control.params.names = A{1};
    control.params.types = A{2};
    control.params.values = A{3};
    
    % keep the file for future save
    control.params.currentFile = file;

end

