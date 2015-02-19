function gitAskSettings(  )
%GITASKSETTINGS Open dialog to change git update settings

    batFolder = fileparts(which('batalef'));
    currFolder = pwd;
    cd(batFolder);
    load('gitSettings.mat');
    Q{1} = 'update ?';
    Q{2} = 'branch';
    D{1} = gitSettings.update;
    D{2} = gitSettings.branch;
    A = inputdlg(Q,'git update settings',[1,50],D);
    if ~isempty(A)
        gitSettings.update = A{1};
        gitSettings.branch = A{2};
        save('gitSettings.mat','gitSettings');
    end
    cd(currFolder);

end

