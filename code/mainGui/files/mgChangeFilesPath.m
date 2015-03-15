function [ output_args ] = mgChangeFilesPath( input_args )
%MGCHANGEFILESPATH 

    global filesObject;
    
    K = mgResolveFilesToWork();
    if isempty(K)
        return;
    end
    
    D{1} = filesObject(K(1)).path;
    A = inputdlg({'Path (applied for all files selected)'},'Change Path',[1,120],D);
    
    if isempty(A)
        return;
    end
    
    for i = 1:length(K)
        filesObject(K(i)).path = A{1};
    end
    
    mgRefreshFilesTable();
    mgRefresh_textDisplayedFile();
    
end