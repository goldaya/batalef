function [ position ] = uiPosition( h, units )
%UIPOSITION get the UI control position in the specified units

    uni = get(h,'Units');
    set(h,'Units',units);
    position = get(h,'Position');
    set(h,'Units',uni);

end

