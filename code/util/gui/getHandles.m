function handles = getHandles( guiName, uiobj )
%GETHANDLES Get gui handles (all / specific ui object)

    handles = guidata(control.(guiName).fig);
    if exist('uiobj','var')
        handles = handles.(uiobj);
    end     

end

