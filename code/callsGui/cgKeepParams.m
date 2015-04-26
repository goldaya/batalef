function [  ] = cgKeepParams(  )
%CGKEEPPARAMS Keep params from screen

    handles = cgGetHandles();
    
    setParam('callsGUI:callWindow', str2double(get(handles.textCallWindow, 'String')));
    setParam('callsGUI:gap', str2double(get(handles.textGap, 'String')));
    setParam('callsGUI:dbStart', str2double(get(handles.textStartDiff,'String')));
    setParam('callsGUI:dbEnd', str2double(get(handles.textEndDiff,'String')));
        
end