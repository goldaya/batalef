function [ rc, failed ] = filterBuilder( K )
%FILTERBUILDER Prompt user for filter configuration through Matlab's
%filterbuilder, then filter the selected files.

    rc = 0;
    failed = [];
    
    if isempty(K)
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
            rc = 0;
        elseif isempty(failed)
            rc = 2;
        else
            rc = 1;
        end
    end
    
    mgRefreshFilesTable();

end

