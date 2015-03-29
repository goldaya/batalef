function [ output_args ] = mgRmClearVerticalLines(  )
%MGRMCLEARVERTICALLINES 

    global control;
    
    startLines = control.mg.Rm.startVerticalLines;
    if ~isempty(startLines)
        for i = 1:length(startLines)
            if ishandle(startLines(i))
                delete(startLines(i));
            end
        end
    end
    endLines = control.mg.Rm.endVerticalLines;
    if ~isempty(endLines)
        for i = 1:length(endLines)
            if ishandle(endLines(i))
                delete(endLines(i));
            end
        end
    end

end

