function [  ] = cgRestoreParams(  )
%CGRESTOREPARAMS Restore Parameters to CallsGUI

    global c;
    handles = cgGetHandles();
    
    set(handles.textCallWindow, 'String', getParam('callsGUI:callWindow'));
    
    set(handles.sliderGap,'Max', getParam('callsGUI:maxGap'));
    set(handles.sliderGap,'SliderStep', [1,1]/(10));    
    gap = getParam('callsGUI:gap');
    set(handles.sliderGap,'Value',gap);
    set(handles.textGap,'String', num2str(gap));
    
    dbStart = getParam('callsGUI:dbStart');
    set(handles.textStartDiff,'String',num2str(dbStart));
    set(handles.sliderStartDiff, 'Value', 1-10^(dbStart/10));
    
    dbEnd = getParam('callsGUI:dbEnd');
    set(handles.textEndDiff,'String',num2str(dbEnd));
    set(handles.sliderEndDiff, 'Value', 1-10^(dbEnd/10));
    
    switch getParam('callsGUI:showValues')
        case c.saved
            set(handles.rbValuesSaved, 'Value', 1);
        case c.calculated
            set(handles.rbValuesCalculated, 'Value', 1);
        case c.mix
            set(handles.rbValuesMix, 'Value', 1);
        otherwise
            set(handles.rbValuesMix, 'Value', 1);
    end

end

