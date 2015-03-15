function [  ] = defmMethodSelected( methodsui, newMethod )
%DEFMMETHODSELECTED Summary of this function goes here
%   Detailed explanation goes here

    n = length(methodsui);
    for i = 1:n
        if get(methodsui(i),'UserData')==newMethod
            set(methodsui(i), 'Checked', 'on')
        else
            set(methodsui(i), 'Checked', 'off')
        end
    end

end

