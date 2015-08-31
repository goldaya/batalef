function fcgPopulateBaseChannelsList( k )
%FCGPOPULATEBASECHANNELSLIST Put all the file's channels in the drop down
%list and select the first

    N = fileData(k,'Channels','Calls');
    S = num2str((1:N)');
    ddBaseChannel = getHandles('fcg','ddBaseChannel');
    set(ddBaseChannel,'String',S);
    set(ddBaseChannel,'Value',1);
    

end

