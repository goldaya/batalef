function [ output_args ] = cgRefresh2Call( input_args )
%CGREFRESH2CALL Summary of this function goes here
%   Detailed explanation goes here

    global control;
    [k,j,s] = cgGetCurrent();
    handles = cgGetHandles();
    
    
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
    control.cg.call = channelCall(k,j,s);
end

