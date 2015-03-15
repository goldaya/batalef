function [  ] = sugInit(  )
%SUGINIT Init the Spectrum GUI - number of axes and parameters values

    global control;
    handles = sugGetHandles();
    
    
    % init the parameters values from the parameters array
    set(handles.textWindow, 'String', num2str(getParam('spectrum:window')));
    
    % resize gui and align with main gui
    set(handles.figure1, 'Units', 'pixels');
    axesHeight = appData('Axes','Height','Total');
    [~,mgFig] = mgGetHandles('figure1');
    mgPosition = get(mgFig,'Position');
    mgOuterPosition = get(mgFig, 'OuterPosition');
    borders = mgPosition - mgOuterPosition;
    sugPosition = [getNextGuiX(handles.figure1)+7*borders(1), mgPosition(2), 300, axesHeight];
    set(handles.figure1, 'Position', sugPosition);
    % push parameters panel up
    panelPosition = get(handles.panelParameters, 'Position');
    panelPosition(2) = panelPosition(2) + axesHeight;
    set(handles.panelParameters,'Position',panelPosition);
    
    % build axes
    n = appData('Axes','Count');
    for i = 1:n;
        axesName = strcat('axes',num2str(i));
        axobj = axes('Parent',handles.figure1,...
            'Tag',axesName, ...
            'Units', 'pixels',...
            'Position',[25,22+(n-i)*control.mg.axesHeight, 250, control.mg.axesHeight-50]);
        handles.(axesName) = axobj;
    end
    guidata(control.sug.fig, handles);


end

