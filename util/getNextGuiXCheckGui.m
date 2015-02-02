function [ nextX ] = getNextGuiXCheckGui( fh, nextX, skip )
%GETNEXTGUIXCHECKGUI Check if figure is alive, then adjust nextX

    if ishandle(fh)
        if fh~=skip
            set(fh, 'Units','pixels');
            outerPosition = get(fh,'OuterPosition');
            rightEdge = outerPosition(3) + outerPosition(1);
            if rightEdge > nextX;
                nextX = rightEdge;
            end
        end
    end

end

