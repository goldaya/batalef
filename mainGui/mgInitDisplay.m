function [  ] = mgInitDisplay(  )
%MGINITDISPLAY Summary of this function goes here
%   Detailed explanation goes here

    global control;
    hObject = control.mg.fig;
    
    % reposition GUI to top right corner
    set(0,'Units','pixels');
    screenSize = get(0,'ScreenSize');
    set(hObject, 'Units', 'pixels');
    guiPosition = get(hObject,'OuterPosition');
    guiPosition(1) = 5;
    guiPosition(2) = -4 + screenSize(4)-guiPosition(4);
    set(hObject, 'OuterPosition', guiPosition);
    
    % create the axes to diaplay
    mgSetAxesNumber(getParam('mainGUI:nAxes'));
    

end

