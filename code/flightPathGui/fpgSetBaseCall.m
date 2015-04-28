function [  ] = fpgSetBaseCall( s, refreshBaseCallsCombo )
%FPGSETBASECALL Summary of this function goes here
%   Detailed explanation goes here

    global control;
    [k,~,j,~] = fpgGetCurrent;
    validateFileChannelCallIndex(k,j,s);
    control.fpg.s = s;
    
    if exist('refreshBaseCallsCombo','var') && refreshBaseCallsCombo
        handles = fpgGetHandle();
        set(handles.ddBaseCalls,'Value',s);
    end
    
    fpgRefreshSeqList();
end

