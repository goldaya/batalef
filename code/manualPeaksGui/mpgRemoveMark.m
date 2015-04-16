function mpgRemoveMark(  )
%MPGREMOVEMARK Summary of this function goes here
%   Detailed explanation goes here
    global control;
    if isfield(control.mpg, 'mark') && ~isempty(control.mpg.mark)
        channelCall.removeCalls(control.mpg.k, control.mpg.j,[control.mpg.mark(1),control.mpg.mark(1)]); 
    end
end

