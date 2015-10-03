function [ position ] = uiPosition( h, units )
%UIPOSITION get the UI control position in the specified units

    uni = get(h,'Units');
    set(h,'Units',units);
    if h == 0
        position = get(0,'ScreenSize');
    else
        position = get(h,'Position');
    end
    set(h,'Units',uni);

end

