function [ output_args ] = mgMpwpdClearVerticalLines(  )
%MGSUCLEARVERTICALLINES Summary of this function goes here
%   Detailed explanation goes here

    global control;
    
    startLines = control.mg.Mpwpd.startVerticalLines;
    if ~isempty(startLines)
        for i = 1:length(startLines)
            if ishandle(startLines(i))
                delete(startLines(i));
            end
        end
    end
    endLines = control.mg.Mpwpd.endVerticalLines;
    if ~isempty(endLines)
        for i = 1:length(endLines)
            if ishandle(endLines(i))
                delete(endLines(i));
            end
        end
    end

end

