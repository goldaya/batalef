function [  ] = mgSoShowVerticalLines( time, type )
%MGSOSHOWVERTICALLINES

    global control;
    
    switch type
        case 'start'
            vlineHandles = control.mg.so.startVerticalLines;
        case 'end'
            vlineHandles = control.mg.so.endVerticalLines;
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
        vlineHandles(i) = plot(axobj,[time,time],[-10,10],'g');
        switch type
            case 'start'
                set(vlineHandles(i), 'ButtonDownFcn', @mgSoStart);
            case 'end'
                set(vlineHandles(i), 'ButtonDownFcn', @mgSoEnd);
        end
        hold(axobj,'off');
    end
    
    % keep
    switch type
        case 'start'
            control.mg.so.startVerticalLines = vlineHandles;
        case 'end'
            control.mg.so.endVerticalLines = vlineHandles;
    end

end
