function [  ] = fpgRefreshFileCallsTable( sel_a )
%PDGFCREFRESHFILECALLSTABLE Refresh contents of the file call table ui
%component

    [k,~,~,a] = fpgGetCurrent();
    handles = fpgGetHandles();
    if ~exist('sel_a','var')
        sel_a = a;
    end
    
    n = fileData(k, 'Calls', 'Count');
    D = cell(n,3);
    for a = 1:n
        if a == sel_a
            D{a,1} = true;
        else
            D{a,1} = false;
        end
        D{a,2} = fileCallData(k, a, 'Time');
        D{a,3} = strcat('[',seq2string(fileCallData(k, a, 'Location')),']');
        D{a,4} = seq2string(fileCallData(k, a, 'ChannelCalls'));
    end
    
    set(handles.uitabFileCalls, 'Data', D);
    
    
    % refresh the files table as the number of file calls has changed
    mgRefreshFilesTable();
    
end

