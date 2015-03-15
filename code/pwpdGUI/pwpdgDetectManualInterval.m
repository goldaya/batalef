function [  ] = pwpdgDetectManualInterval( I )
%PWPDGDETECTMANUALINTERVAL Summary of this function goes here
%   Detailed explanation goes here

    global control;
    
    control.status = 'Piecewise peak detection';
    [do, percentile, minDistance, replace, channel, filter] = pdBasicAsk();
    
    if ~do
        control.status = 'Idle';
        return;
    end
    
    k = appData('Files','Displayed');
    pdPiecewise(k,I,percentile, minDistance, channel, filter, replace);
    
    mgRefreshAxes();
    control.status = 'Finished piecewise peak detection';
    msgbox(control.status);

end

