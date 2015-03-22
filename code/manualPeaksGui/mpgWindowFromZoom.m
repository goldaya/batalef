function mpgWindowFromZoom()
%MPGWINDOWFROMZOOM - INTERNAL - get window (time & value) from current zoom

    global control;
    handles = mpgGetHandles();
    xlim = get(handles.axes1,'XLim');
    ylim = get(handles.axes1,'YLim');
    xdiff = xlim(2)-xlim(1);
    ydiff = ylim(2)-ylim(1);
    control.mpg.window.time = xdiff * 1000;
    control.mpg.window.value = ydiff;
    set(handles.textTimeWindow,'String',num2str(control.mpg.window.time));
    set(handles.textValueWindow,'String',num2str(control.mpg.window.value));
    setParam('peaks:manual:window:time',control.mpg.window.time);
    setParam('peaks:manual:window:value',control.mpg.window.value);
    

end

