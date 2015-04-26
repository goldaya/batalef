function [  ] = cgRestoreParams(  )
%CGRESTOREPARAMS Restore Parameters to CallsGUI

    global control;
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
    
    % filter
    switch getParam('callsGUI:filter:method')
        case c.none
            control.cg.filter = [];
            set(handles.ddFilter,'Value',1);
        case c.butter
            control.cg.filter.method = c.butter;
            control.cg.filter.type   = getParam('callsGUI:filter:butter:type');
            control.cg.filter.order  = getParam('callsGUI:filter:butter:order');
            control.cg.filter.f1     = getParam('callsGUI:filter:butter:f1')*1000;
            control.cg.filter.f2     = getParam('callsGUI:filter:butter:f2')*1000;
            set(handles.ddFilter,'Value',2);
        otherwise
            control.cg.filter = [];
            set(handles.ddFilter,'Value',1);
    end
    
end

