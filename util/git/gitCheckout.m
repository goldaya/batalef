function gitCheckout( branch )
%GITCHECKOUT Replace branch
    
    if ~exist('branch','var') || isempty(branch)
        branchCell = inputdlg('Branch','git change branch',[1,50],{'master'});
        if isempty(branchCell)
            msgbox('git pull aborted');
            return;
        else
            branch = branchCell{1};
        end
    end

    gitCommand = strcat(['git checkout ', branch]);
    eval(gitCommand);
    gitCommand = 'git status';
    eval(gitCommand);
end

