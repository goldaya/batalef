function [  ] = initG(  )
%INITG Update through git


    % change working folder
    batFolder = fileparts(which('batalef'));
    currFolder = pwd;
    cd(batFolder);
    
    % dont do?
    load('gitSettings.mat');
    if ~strcmp(gitSettings.update,'Yes')
        disp('git update disabled');
        cd(currFolder);
        return;
    end
    
    [gitStatus,gitBranch]=gitCheckStatus();
    if gitStatus > 0
        switch gitStatus
            case 1
                disp('git is absent')
            case 2
                disp('no git repo')
        end
        disp('aborting git update')
        cd(currFolder);
        return;
    end

    % pull from github
    gitPull(gitBranch);
    cd(currFolder);

end

