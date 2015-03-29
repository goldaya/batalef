function [  ] = fpgRefreshFileCallsTable(  )
%PDGFCREFRESHFILECALLSTABLE -INTERNAL- Refresh contents of the file call 
%table ui component

    k = fpgGetCurrent();
    handles = fpgGetHandles();
    
    n = fileData(k, 'Calls', 'Count');
    D = cell(n,3);
    for a = 1:n
        D{a,1} = fileCallData(k, a, 'Time');
        D{a,2} = strcat('[',seq2string(fileCallData(k, a, 'Location')),']');
        D{a,3} = seq2string(fileCallData(k, a, 'ChannelCalls'));
    end
    
    set(handles.uitabFileCalls, 'Data', D);
    
    
    % refresh the files table as the number of file calls has changed
    mgRefreshFilesTable();
    
end

