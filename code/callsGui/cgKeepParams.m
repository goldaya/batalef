function [  ] = cgKeepParams(  )
%CGKEEPPARAMS Keep params from screen

    global control;
    global c;
    handles = cgGetHandles();
    
    setParam('callsGUI:callWindow', str2double(get(handles.textCallWindow, 'String')));
    setParam('callsGUI:gap', str2double(get(handles.textGap, 'String')));
    setParam('callsGUI:dbStart', str2double(get(handles.textStartDiff,'String')));
    setParam('callsGUI:dbEnd', str2double(get(handles.textEndDiff,'String')));
    setParam('callsGUI:detectionPeakWindow', str2double(get(handles.textD2P, 'String'))./1000);
    
    % filter
    switch get(handles.ddFilter, 'Value');
        case 1
            setParam('callsGUI:filter:method',c.none);
        case 2
            setParam('callsGUI:filter:method',      c.butter);
            setParam('callsGUI:filter:butter:type', control.cg.filter.type);
            setParam('callsGUI:filter:butter:order',control.cg.filter.order);
            setParam('callsGUI:filter:butter:f1',   control.cg.filter.f1/1000);
            setParam('callsGUI:filter:butter:f2',   control.cg.filter.f2/1000);
    end
        
end