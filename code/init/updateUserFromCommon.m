function updateUserFromCommon(  )
%UPDATEUSERFROMCOMMON - INTERNAL - Make sure that "user" data contain needed data.

    %%% defaults.bpf
    % open current user default.bpf - use empty cells if non-existent
    fid = fopen('./user/default.bpf');
    if fid == -1
        U{1} = cell(0,1);
        U{2} = cell(0,1);
        U{3} = cell(0,1);
    else
        U = textscan(fid, '%s %s %f'); % name, type, value(float)
        fclose(fid);
        U{3} = num2cell(U{3});
    end
    
    % enforce common default parameters
    U = enforceCommonDefaults(U);
    
    % save updated parameters file
    fid = fopen('./user/default.bpf', 'wt');
    for i=1:size(U{1},1)
        fprintf(fid, '%s %s %f \n', ...
            U{1}{i},...
            U{2}{i},...
            U{3}{i}...
            );
    end
    fclose(fid);
    
    
    %%% gitSettings.mat
    C = load('./common/gitSettings.mat');
    try
        U = load('./user/gitSettings.mat');
        gitSettings = U.gitSettings;
        F = fieldnames(C.gitSettings);
        for i = 1:size(F,1)
            if ~isfield(gitSettings,F(i))
                gitSettings.(F(i)) = C.gitSettings.F(i);
            end
        end
    catch err
        if strcmp(err.identifier,'MATLAB:load:couldNotReadFile')
            gitSettings = C.gitSettings;
        else
            throw(err);
        end
    end
    save('./user/gitSettings.mat','gitSettings');

end

