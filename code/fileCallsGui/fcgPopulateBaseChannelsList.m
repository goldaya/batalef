function fcgPopulateBaseChannelsList( k )
%FCGPOPULATEBASECHANNELSLIST Put all the file's channels in the drop down
%list and select the first

    N = fileData(k,'Channels','Count');
    S = num2str((1:N)');
    S = mat2cell(S,ones(size(S,1),1),size(S,2));
    ddBaseChannel = getHandles('fcg','ddBaseChannel');
    set(ddBaseChannel,'String',S);
    set(ddBaseChannel,'Value',1);
    

end

