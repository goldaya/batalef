function mgMpZoom( hObject, Rx, Ry )
%MGMPZOOM Summary of this function goes here
%   Detailed explanation goes here

    global control
    
    % dont trail mouse when locked
    if control.mpg.locked
        return;
    end

    xlim = get(hObject, 'XLim');
    xdiff = xlim(2)-xlim(1);
    tc = xlim(1)+Rx.*xdiff;

    ylim = get(hObject, 'YLim');
    ydiff = ylim(2)-ylim(1);
    vc = ylim(1)+Ry.*ydiff;
 
    axesName = get(hObject, 'Tag');
    axesNumber = str2double(axesName(5));
    J = appData('Channels','Displayed');
    if ~isempty(J(axesNumber))
        mpgPlot( J(axesNumber), tc, vc );
    end
    
end

