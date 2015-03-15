function [ rc, failed ] = filterButter( K )
%FILTERBUTTRER Filter Selected files

    failed = [];
    
    if isempty(K)
        rc = 3;
        return;
    end
    
    params = filterButterDlg();
    if isempty(params)
        rc = 4;
        return;
    end
    
    for i = 1:length(K)
        Fs = fileData(K(i),'Fs');
        filterObject = filterButterMake(Fs,params.type,params.order,params.f1,params.f2);
        ok = filterFile(K(i),filterObject);
        if ~ok
            failed = [failed, K(i)];
        end
    end
    
    
    switch length(failed)
        case 0
            rc = 0;
        case length(K)
            rc = 2;
        otherwise
            rc = 1;
    end
    
    if rc < 2
        mgRefreshFilesTable();
    end


end

