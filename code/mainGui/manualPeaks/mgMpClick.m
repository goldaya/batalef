function [  ] = mgMpClick( hObject, eventdata, handles  )
%MGMPCLICK Summary of this function goes here
%   Detailed explanation goes here

    global control;
    
    % do only when in manual peak detection mode (mpg on)
    if ~isfield(control.mpg,'fig') || isempty(control.mpg.fig) || ~ishandle(control.mpg.fig)
        return;
    end
    
    b = get(control.mg.fig, 'selectiontype');
    switch b
        case 'normal' % left mouse button
            if ~control.mpg.locked && isfield(control.mpg, 'zoomPeak')
                mpgAddPeak( control.mpg.zoomPeak );
            end
            control.mpg.locked = not(control.mpg.locked);
        case 'alt' % right mouse button
            mpgRemovePeaks( );
        case 'open' % double click (either button)
            
    end
end