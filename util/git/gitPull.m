function gitPull( branch )
%GITPULL pull batalef from git
    
    if ~exist('branch','var') || isempty(branch)
        branchCell = inputdlg('Branch','Pull batalef from git',[1,50],{'master'});
        if isempty(branchCell)
            msgbox('git pull aborted');
            return;
        else
            branch = branchCell{1};
        end
    end

    gitCommand = strcat(['git checkout ', branch]);
    eval(gitCommand);
    gitCommand = strcat(['git pull https://github.com/uido123/batalef.git ',branch]);
    eval(gitCommand);
end

