function mpgInit()
%MPGINIT - INTERNAL - Initialization script for manual peaks gui

    global control;
    handles = mpgGetHandles();
    set(control.mpg.fig, 'Units','pixels');
    
    % align gui with main gui
    % get border, top and right outer positions of main gui
    mgOuter = get(control.mg.fig, 'OuterPosition');
    %mgInner = get(control.mg.fig, 'Position');
    %mgBorder = mgOuter - mnInner;
    top = mgOuter(2) + mgOuter(4);
    right = mgOuter(1) + mgOuter(3);
    pos = get(control.mpg.fig, 'Position');
    pos(1) = right;
    pos(2) = top - pos(4) + 10;
    set(control.mpg.fig, 'Position', pos);
    
    % init window
    control.mpg.window.value = getParam('peaks:manual:window:value');
    control.mpg.window.time  = getParam('peaks:manual:window:time' );
    set(handles.textTimeWindow,'String',num2str(control.mpg.window.time));
    set(handles.textValueWindow,'String',num2str(control.mpg.window.value));
    
    % hide ticks
    set(handles.axes1,'xtick',[])
    set(handles.axes1,'xticklabel',[])
    set(handles.axes1,'ytick',[])
    set(handles.axes1,'yticklabel',[])    
end

