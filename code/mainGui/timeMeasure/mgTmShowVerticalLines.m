function [  ] = mgTmShowVerticalLines( time, type )
%MGTMSHOWVERTICALLINES Summary of this function goes here
%   Detailed explanation goes here

    global control;
    
    switch type
        case 'start'
            vlineHandles = control.mg.tm.startVerticalLines;
        case 'end'
            vlineHandles = control.mg.tm.endVerticalLines;
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
        X = get(axobj,'Xlim');
        Y = get(axobj,'Ylim');        
        hold(axobj,'on') ;
        vlineHandles(i) = plot(axobj,[time,time],[-10,10],'r');
        set(axobj,'Xlim',X);
        set(axobj,'Ylim',Y); 
        switch type
            case 'start'
                set(vlineHandles(i), 'ButtonDownFcn', @mgTmStart);
            case 'end'
                set(vlineHandles(i), 'ButtonDownFcn', @mgTmEnd);
        end
        hold(axobj,'off');
    end
    
    % keep
    switch type
        case 'start'
            control.mg.tm.startVerticalLines = vlineHandles;
        case 'end'
            control.mg.tm.endVerticalLines = vlineHandles;
    end

end
