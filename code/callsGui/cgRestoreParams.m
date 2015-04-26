function [  ] = cgRestoreParams(  )
%CGRESTOREPARAMS Restore Parameters to CallsGUI

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
    
end

