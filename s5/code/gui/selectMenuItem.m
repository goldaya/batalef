function selectMenuItem( menu, userData )
%SELECTMENUITEM Select (visually) the desired menu item

    C = get(menu,'Children');
    for i = 1:length(C)
        UD = get(C(i),'UserData');
        if strcmp(UD{1},userData)
            set(C(i),'Checked','on');
        else
            set(C(i),'Checked','off');
        end
    end
end

