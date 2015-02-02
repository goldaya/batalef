function [ rc ] = filterButter( K )
%FILTERBUTTRER Filter Selected files

    if isempty(K)
        return;
    end
    
    params = filterButterDlg();
    if isempty(params)
        rc = 0;
        return;
    end
    
    ok = zeros(length(K),1);
    for i = 1:length(K)
        Fs = fileData(K(i),'Fs');
        filterObject = filterButterMake(Fs,params.type,params.order,params.f1,params.f2);
        ok(i) = filterFile(K(i),filterObject);
    end
    
    if min(ok) > 0
        rc = 2;
    elseif max(ok) < 1
        rc = 0;
    else
        rc = 1;
    end
    
    mgRefreshFilesTable();


end

