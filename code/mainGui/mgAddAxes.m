function [  ] = mgAddAxes( n )
%MGADDAXES Add n axes objects, adjust GUI size and compos positions

    global control;
    global c;
    handles = mgGetHandles();
    
    dGuiHeight = n*control.mg.axesHeight;
    N = control.mg.nAxes;
    
    % resize GUI
    guiPosition = get(control.mg.fig, 'Position');
    guiPosition(2) = guiPosition(2) - dGuiHeight;
    guiPosition(4) = guiPosition(4) + dGuiHeight;
    set(control.mg.fig, 'Position', guiPosition);
    
    % push files table up
    tabPosition = get(handles.topPanel, 'Position');
    tabPosition(2) = tabPosition(2) + dGuiHeight;
    set(handles.topPanel, 'Position', tabPosition);
    
    % reconfigure slider
    sliderPosition = get(handles.sliderChannels, 'Position');
    sliderPosition(4) = sliderPosition(4) + dGuiHeight;
    set(handles.sliderChannels, 'Position', sliderPosition);
    mgSetSlider(false);
    
    % push existing axes up
    for i = 1:N
        axesName = strcat('axes',num2str(i));
        axesHandle = handles.(axesName);
        axesPosition = get(axesHandle, 'Position');
        axesPosition(2) = axesPosition(2) + dGuiHeight;
        set(axesHandle, 'Position', axesPosition);
    end
    
    % new axes objects
    for i = 1:n
        num = i+N;
        axesName = strcat('axes',num2str(num));
        axesPosition = [25,22+(n-i)*control.mg.axesHeight,560,control.mg.axesHeight-50];
        axesObject = axes('Parent',control.mg.fig,...
            'Units','pixels', ...
            'Position', axesPosition, ...
            'Tag',axesName);
        handles.(axesName) = axesObject;
    end
    guidata(control.mg.fig, handles);
    
    % 
    control.mg.nAxes = N + n;
    setParam('mainGUI:nAxes',N + n);
    
    % link ?
    mgLinkAxes(control.mg.linkAxes);
    %{
    if control.mg.axesMode == c.link
        mgLinkAxes( true );
    end
    %}
    

end

