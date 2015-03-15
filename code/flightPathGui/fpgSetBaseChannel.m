function [  ] = fpgSetBaseChannel( j, refreshChannelsCombo )
%FPGSETBASECHANNEL Summary of this function goes here
%   Detailed explanation goes here

    global control;
    k = fpgGetCurrent;
    validateFileChannelIndex(k,j);
    control.fpg.j = j;
    
    if exist('refreshChannelsCombo','var') && refreshChannelsCombo
        handles = fpgGetHandles();
        set(handles.ddBaseChannel, 'Value', j);
    end
    
    fpgRefreshBaseCallsList();
    
end

