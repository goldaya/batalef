function gitAskSettings(  )
%GITASKSETTINGS Open dialog to change git update settings

    batFolder = fileparts(which('batalef'));
    fullpath = strcat(batFolder,filesep(),'user',filesep(),'gitSettings.mat');
    load(fullpath);
    Q{1} = 'update ?';
    Q{2} = 'repository';
    Q{3} = 'branch';
    D{1} = gitSettings.update;
    D{2} = gitSettings.repo;
    D{3} = gitSettings.branch;
    A = inputdlg(Q,'git update settings',[1,50],D);
    if ~isempty(A)
        gitSettings.update = A{1};
        gitSettings.repo   = A{2};
        gitSettings.branch = A{3};
        save(fullpath,'gitSettings');
    end

end