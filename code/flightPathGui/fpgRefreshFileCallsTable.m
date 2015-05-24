function [  ] = fpgRefreshFileCallsTable(  )
%PDGFCREFRESHFILECALLSTABLE -INTERNAL- Refresh contents of the file call 
%table ui component

    k = fpgGetCurrent();
    handles = fpgGetHandles();
    
    N = fileData(k,'Channels','Count');
    n = fileData(k, 'Calls', 'Count');
    D = cell(n,2+N);
    
    for a = 1:n
        D{a,1} = fileCallData(k, a, 'Time');
        D{a,2} = strcat('[',seq2string(fileCallData(k, a, 'Location')),']');
        seq = fileCallData(k, a, 'ChannelCalls');
        for j = 1:N
            D{a,2+j} = seq(j);
        end
    end
    
    set(handles.uitabFileCalls, 'Data', D);
    
    
    % refresh the files table as the number of file calls has changed
    mgRefreshFilesTable();
    
end

