function [  ] = mgRemoveAxes( n )
%MGREMOVEAXES Remove n axes object from and of gui, resize gui and
%reposition compos

    global control;
    handles = mgGetHandles();
    
    dGuiHeight = n*control.mg.axesHeight;
    N = control.mg.nAxes;
    M = N - n;
    if M < 1
        return;
    end
    
    % remove axes objects
    for i = M + 1 : N
        axesName = strcat('axes',num2str(i));
        delete(handles.(axesName));
        handles = rmfield(handles,axesName);
    end
    guidata(control.mg.fig, handles);
    
    % reposition remaining axes objects
    for i = 1:M
        axesName = strcat('axes',num2str(i));
        axesHandle = handles.(axesName);
        axesPosition = get(axesHandle, 'Position');
        axesPosition(2) = axesPosition(2) - dGuiHeight;
        set(axesHandle, 'Position', axesPosition);
    end
    
    % reconfigure slider
    sliderPosition = get(handles.sliderChannels, 'Position');
    sliderPosition(4) = sliderPosition(4) - dGuiHeight;
    set(handles.sliderChannels, 'Position', sliderPosition);
    mgSetSlider(false);
    
    % reposition files table
    tabPosition = get(handles.topPanel, 'Position');
    tabPosition(2) = tabPosition(2) - dGuiHeight;
    set(handles.topPanel, 'Position', tabPosition);
    
    % resize GUI
    guiPosition = get(control.mg.fig, 'Position');
    guiPosition(2) = guiPosition(2) + dGuiHeight;
    guiPosition(4) = guiPosition(4) - dGuiHeight;
    set(control.mg.fig, 'Position', guiPosition);

    %
    control.mg.nAxes = M;
    setParam('mainGUI:nAxes',M);
    
    % link axes
    mgLinkAxes(control.mg.linkAxes);
end

