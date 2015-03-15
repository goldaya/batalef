function [ output_args ] = mgChangeFilePathName( K )
%MGCHANGEFILEPATHNAME 

    global filesObject;
    
    if ~exist('K','var')
        K = mgResolveFilesToWork();
    end
    if isempty(K)
        return;
    end
    
    for i = 1:length(K)
        k = K(i);
        D{1} = filesObject(k).path;
        D{2} = filesObject(k).name;
        A = inputdlg({'Path','Name'},'Change single file path and name',[1,120],D);
        
        if isempty(A)
            return;
        end
        
        filesObject(k).path = A{1};
        filesObject(k).name = A{2};
        
    end
    
    mgRefreshFilesTable();
    mgRefresh_textDisplayedFile();

end

