function [  ] = updateFromGit(  )
%UPDATEFROMGIT Update through git


    disp('  git update:');
    
    % dont do?
    load('/user/gitSettings.mat');
    if ~strcmp(gitSettings.update,'Yes')
        disp('  git update disabled');
        return;
    end
    
    [gitStatus,gitBranch] = gitCheckStatus();
    if gitStatus > 0
        switch gitStatus
            case 1
                disp('  git is absent')
            case 2
                disp('  no git repo')
        end
        disp('  aborting git update')
        return;
    else
        disp(strcat(['  git OK. Current branch: ',gitBranch]));
    end

    % pull from github
    disp(strcat(['  Updating from git. Branch: ',gitSettings.branch,' ; repo: ',gitSettings.repo]));
    disp(' ');
    gitPull(gitSettings.repo, gitSettings.branch);
    disp(' ');
    disp('  git update finished');

end

