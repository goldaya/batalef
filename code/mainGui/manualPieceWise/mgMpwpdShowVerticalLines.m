function [  ] = mgMpwpdShowVerticalLines( time, type )
%MGSUSHOWVERTICALLINES

    global control;
    
    switch type
        case 'start'
            vlineHandles = control.mg.Mpwpd.startVerticalLines;
        case 'end'
            vlineHandles = control.mg.Mpwpd.endVerticalLines;
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
        vlineHandles(i) = plot(axobj,[time,time],[-10,10],'b-.');
        switch type
            case 'start'
                set(vlineHandles(i), 'ButtonDownFcn', @mgMpwpdStart);
            case 'end'
                set(vlineHandles(i), 'ButtonDownFcn', @mgMpwpdEnd);
        end
        hold(axobj,'off');
    end
    
    % keep
    switch type
        case 'start'
            control.mg.Mpwpd.startVerticalLines = vlineHandles;
        case 'end'
            control.mg.Mpwpd.endVerticalLines = vlineHandles;
    end

end
