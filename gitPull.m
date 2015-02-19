function gitPull( branch )
%GITPULL pull batalef from git
    
    if ~exist('branch','var') || isempty(branch)
        branch = inputdlg('Branch','Pull batalef from git',[1,50],{'master'});
        if isempty(branch)
            msgbox('git pull aborted');
            return;
        end
    end

    gitCommand = strcat(['git checkout ', branch{1}]);
    eval(gitCommand);
    gitCommand = strcat(['git pull https://github.com/uido123/batalef.git ',branch{1}]);
    eval(gitCommand);
end

