function [  ] = sogInit(  )
%SOGINIT Init the Spectrogram GUI - number of axes and parameters values

    global control;
    handles = sogGetHandles();
    
    % resize gui and align with main gui
    axesHeight = appData('Axes','Height','Total');
    [~,mgFig] = mgGetHandles('figure1');
    mgPosition = get(mgFig,'Position');
    mgOuterPosition = get(mgFig, 'OuterPosition');
    borders = mgPosition - mgOuterPosition;
    sogPosition = [getNextGuiX(handles.figure1)+7*borders(1), mgPosition(2), 300, 0 + axesHeight];
    set(handles.figure1, 'Position', sogPosition);
    
    %{
    % push parameters panel up
    panelPosition = get(handles.panelParameters, 'Position');
    panelPosition(2) = panelPosition(2) + axesHeight;
    set(handles.panelParameters,'Position',panelPosition);
    %}
    
    % build axes
    n = appData('Axes','Count');
    for i = 1:n;
        axesName = strcat('axes',num2str(i));
        axobj = axes('Parent',handles.figure1,...
            'Tag',axesName, ...
            'Units', 'pixels',...
            'Position',[25,22+(n-i)*control.mg.axesHeight, 250, control.mg.axesHeight-50]);
        handles.(axesName) = axobj;
        set(axobj,'Units','normalized');
    end
    guidata(control.sog.fig, handles);

end

