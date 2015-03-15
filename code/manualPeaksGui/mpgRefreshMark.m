function mpgRefreshMark(  )
%MPGREFRESHMARK Summary of this function goes here
%   Detailed explanation goes here

    global control;
    handles = mpgGetHandles();
    
    if isfield(control.mpg, 'hMark') && ~isempty(control.mpg.hMark) && ishandle(control.mpg.hMark)
        delete(control.mpg.hMark);
    end
    hold(handles.axes1, 'on');
    control.mpg.hMark = plot(handles.axes1, control.mpg.mark(1), control.mpg.mark(2), '*g');
    hold(handles.axes1, 'off');
end

