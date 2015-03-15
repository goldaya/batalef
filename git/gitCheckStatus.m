function [ rc, branch ] = gitCheckStatus( allowInit )
%GITCHECKSTATUS Check if git and repository exist

    branch  = '';
    if ~exist('allowInit','var')
        allowInit = true;
    end
    
    try
        a = evalc('git status');
    catch err
        if strcmp(err.identifier,'MATLAB:UndefinedFunction')
            % git wrapper is absent
            rc = 1;
            return;
        else
            % some other error
            % throw(err);
            rc = 3;
            return;
        end
    end
    
    if strcmp(a(1:5),'fatal')
    % no repo
        
        % try to init repo
        if strcmp(a(7:27),'Not a git repository') && allowInit
            git init;
            [ rc, branch ] = gitCheckStatus( false );
            return;
        end
        
        rc = 2;
        return;
    end
    
    % all ok
    rc = 0;
    lSpace = strfind(a,' ');
    lChang = strfind(a,'Chang');
    branch = a(lSpace(2)+1:lChang(1)-2);

end

