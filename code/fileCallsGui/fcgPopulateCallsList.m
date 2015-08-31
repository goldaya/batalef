function  fcgPopulateCallsList( k )
%FCGPOPULATECALLSLIST populate the file calls list uitable

    Nchannels = fileData(k,'Channels','Count');
    Ncalls = fileData(k,'Calls','Count');

    D = cell(n,2+Nchannels);
    
    for a = 1:Ncalls
        D{a,1} = fileCallData(k, a, 'Time');
        D{a,2} = strcat('[',seq2string(fileCallData(k, a, 'Location')),']');
        seq = fileCallData(k, a, 'ChannelCalls');
        for j = 1:NChannels
            D{a,2+j} = seq(j);
        end
    end
    
    uitab = getHandles('fcg','uitabFileCalls');
    set(uitab,'Data',D);
    
end

