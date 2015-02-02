function mpgRemoveMark(  )
%MPGREMOVEMARK Summary of this function goes here
%   Detailed explanation goes here
    global control;
    if isfield(control.mpg, 'mark') && ~isempty(control.mpg.mark)
        Fs = fileData(control.mpg.k,'Fs');
        removeChannelCalls(control.mpg.k, control.mpg.j, 'DetectionBetween', [floor((control.mpg.mark(1))*Fs),ceil((control.mpg.mark(1))*Fs)]); 
    end
end

