function [  ] = cgKeepParams(  )
%CGKEEPPARAMS Keep params from screen

    global c;
    handles = cgGetHandles();
    
    setParam('callsGUI:callWindow', str2double(get(handles.textCallWindow, 'String')));
    setParam('callsGUI:gap', str2double(get(handles.textGap, 'String')));
    setParam('callsGUI:dbStart', str2double(get(handles.textStartDiff,'String')));
    setParam('callsGUI:dbEnd', str2double(get(handles.textEndDiff,'String')));
    
    if get(handles.rbValuesSaved, 'Value')
       setParam('callsGUI:showValues', c.saved);
    elseif get(handles.rbValuesCalculated, 'Value')
        setParam('callsGUI:showValues', c.calculated);
    else
        setParam('callsGUI:showValues', c.mix);
    end

    
end