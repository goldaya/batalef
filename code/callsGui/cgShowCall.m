function [  ] = cgShowCall(  )
%CGSHOWCALL Show a call based on "current" indexes. to switch call use
%"cgGotoCall"


    global control;
    [k,j,s,t] = cgGetCurrent();
    handles   = cgGetHandles();
    
    
    % indexes
    set(handles.textFileIndex, 'String', k);
    set(handles.textFilesTotal, 'String' ,...
        strcat(['/ ',num2str(appData('Files','Count'))]));
    set(handles.textChannelIndex, 'String', j);
    set(handles.textChannelsTotal, 'String' ,...
        strcat(['/ ',num2str(fileData(k,'Channels','Count'))]));    
    set(handles.textCallIndex, 'String', s);
    set(handles.textCallsTotal, 'String' ,...
        strcat(['/ ',num2str(channelData(k,j,'Calls','Count'))]));    
    
    % create call object
    control.cg.call = channelCall(k,j,s,t,false);
    
    % plots, measurments, etc
    cgRefresh();
    
end

