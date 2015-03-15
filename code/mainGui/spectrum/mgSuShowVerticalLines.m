function [  ] = mgSuShowVerticalLines( time, type )
%MGSUSHOWVERTICALLINES

    global control;
    
    switch type
        case 'start'
            vlineHandles = control.mg.su.startVerticalLines;
        case 'end'
            vlineHandles = control.mg.su.endVerticalLines;
    end
    
    % first delete older lines
    if ~isempty(vlineHandles)
        for i = 1:length(vlineHandles)
            if ishandle(vlineHandles(i))
                delete(vlineHandles(i));
            end
        end
    end
    
    
    % put new vertical lines
    handles = mgGetHandles;
    nAxes = appData('Axes','Count');
    vlineHandles = zeros(nAxes,1);
    for i=1:nAxes
        axesName = strcat('axes',num2str(i));
        axobj = handles.(axesName);
        hold(axobj,'on') ;
        vlineHandles(i) = plot(axobj,[time,time],[-10,10],'g-.');
        switch type
            case 'start'
                set(vlineHandles(i), 'ButtonDownFcn', @mgSuStart);
            case 'end'
                set(vlineHandles(i), 'ButtonDownFcn', @mgSuEnd);
        end
        hold(axobj,'off');
    end
    
    % keep
    switch type
        case 'start'
            control.mg.su.startVerticalLines = vlineHandles;
        case 'end'
            control.mg.su.endVerticalLines = vlineHandles;
    end

end
