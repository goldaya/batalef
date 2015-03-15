function [  ] = pwpdgInit(  )
%PWPDGINIT Summary of this function goes here
%   Detailed explanation goes here

    % align gui with main gui
    [~,pwpdgFig] = pwpdgGetHandles('figure1');
    pwpdgPosition = get(pwpdgFig,'Position');
    [~,mgFig] = mgGetHandles('figure1');
    mgPosition = get(mgFig,'Position');
    pwpdgPosition(2) = mgPosition(4)+mgPosition(2)-pwpdgPosition(4)+20;
    set(pwpdgFig,'Position',pwpdgPosition);
    
    % init values
    handles = pwpdgGetHandles();
    window = num2str(getParam('peaks:pwWindow'));
    overlap = num2str(getParam('peaks:pwOverlap'));
    set(handles.textWindow, 'String', window);
    set(handles.textOverlap, 'String', overlap);
    
end

