function gitPull( repo, branch )
%GITPULL pull batalef from git
    
    if nargin < 2 || isempty(branch) || isempty(repo)
        A = inputdlg({'Repository URL','Branch'},'Pull batalef from git',[1,50]);
        if isempty(A)
            msgbox('git pull aborted');
            return;
        else
            branch = A{2};
            repo = A{1};
        end
    end

    % set remote origin
    gitCommand = strcat(['git remote set-url origin ', repo]);
    eval(gitCommand);
    
    % fetch
    gitCommand = 'git fetch';
    eval(gitCommand);
    
    % change branch
    gitCommand = strcat(['git checkout ', branch]);
    eval(gitCommand);

    %gitCommand = strcat(['git pull https://github.com/uido123/batalef.git ',branch]);
    %eval(gitCommand);

end

