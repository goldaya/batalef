function [ rc, failed ] = filterBuilder( K )
%FILTERBUILDER Prompt user for filter configuration through Matlab's
%filterbuilder, then filter the selected files.

    failed = [];
    
    if isempty(K)
        rc = 3;
        return;
    end
    
    filterObject = filterBuilderGetFilter();
    if isempty(filterObject)
        
        return;
    else
  
        for i = 1:length(K)
            ok = filterFile(K(i),filterObject);
            if ~ok
                failed = [failed,K(i)];
            end
        end
        
        if length(failed) == length(K)
            rc = 2;
        elseif isempty(failed)
            rc = 0;
        else
            rc = 1;
        end
    end
    
    if rc < 2
        mgRefreshFilesTable();
    end

end

