function [  ] = mgRefreshFilesTable(  )
%MGREFRESHFILESTABLE Refresh the displayed files info
    
    [~,tabFiles] = mgGetHandles('tabFiles');
    N = appData('Files','Count');
    
   
    % display files in table
    D = cell(N,3);
    for k = 1:N
        D{k,1} = fileData(k,'isSelected');
        D{k,2} = fileData(k,'Fullpath');
        D{k,3} = fileData(k,'Length');
        D{k,4} = fileData(k,'Fs');
        D{k,5} = fileData(k,'nChannels');
        D{k,6} = fileData(k,'Calls','Count');
        D{k,7} = fileData(k,'DataStatus');
    end
    set(tabFiles, 'Data', D);
    
end

