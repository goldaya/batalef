function [ sel ] = comboSelected( h )
%COMBOSELECTED Get selected string from a combobox handle

    S = get(h,'String');
    if iscell(S)
        v = get(h,'Value');
        sel = S{v};
    else
        sel = S;
    end

end

