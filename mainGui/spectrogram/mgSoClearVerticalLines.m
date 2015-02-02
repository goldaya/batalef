function [ output_args ] = mgSoClearVerticalLines( input_args )
%MGSOCLEARVERTICALLINES Summary of this function goes here
%   Detailed explanation goes here

    global control;
    
    if isfield(control.mg.so,'startVerticalLines')
        startLines = control.mg.so.startVerticalLines;
    else
        startLines = [];
    end
    if ~isempty(startLines)
        for i = 1:length(startLines)
            if ishandle(startLines(i))
                delete(startLines(i));
            end
        end
    end
    
    if isfield(control.mg.so,'endVerticalLines') 
        endLines = control.mg.so.endVerticalLines;
    else
        endLines = [];
    end
    if ~isempty(endLines)
        for i = 1:length(endLines)
            if ishandle(endLines(i))
                delete(endLines(i));
            end
        end
    end

end

