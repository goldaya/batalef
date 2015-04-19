function cgInitIndexes(  )
%CGINITINDEXES -INTERNAL- reset the indexes boundries

    global control;
    handles = cgGetHandles();
    
    % indexes
    set(handles.textFilesTotal, 'String' ,...
        strcat(['/ ',num2str(appData('Files','Count'))]));
    set(handles.textChannelsTotal, 'String' ,...
        strcat(['/ ',num2str(fileData(control.cg.k,'Channels','Count'))]));    
    set(handles.textCallsTotal, 'String' ,...
        strcat(['/ ',num2str(channelData(control.cg.k,control.cg.j,'Calls','Count'))]));        

end

