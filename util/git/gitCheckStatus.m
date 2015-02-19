function [ rc, branch ] = gitCheckStatus(  )
%GITCHECKSTATUS Check if git and repository exist

    branch  = '';
    
    try
        a = evalc('git status');
    catch err
        if strcmp(err.identifier,'MATLAB:UndefinedFunction')
            % git wrapper is absent
            rc = 1;
            return;
        else
            % some other error
            throw(err);
        end
    end
    
    if strcmp(a(1:5),'fatal')
        % no repo
        rc = 2;
        return;
    end
    
    % all ok
    rc = 0;
    lSpace = strfind(a,' ');
    lChang = strfind(a,'Chang');
    branch = a(lSpace(2)+1:lChang(1)-2);

end

