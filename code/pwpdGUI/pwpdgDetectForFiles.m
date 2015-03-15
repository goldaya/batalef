function [  ] = pwpdgDetectForFiles(  )
%PWPDGDETECTFORFILES Summary of this function goes here
%   Detailed explanation goes here
    
    global control;
    
    control.status = 'Piecewise peak detection';
    [do, percentile, minDistance, replace, channel, filter] = pdBasicAsk();
    
    if ~do
        control.status = 'Idle';
        return;
    end
    
    K = mgResolveFilesToWork();
    if ~isempty(K)
        for i = 1:length(K)
            I = pwpdgSetIntervals(K(i));
            pdPiecewise(K(i),I,percentile, minDistance, channel, filter, replace);
        end
    end
    
    mgRefreshAxes();
    control.status = 'Finished piecewise peak detection';
    msgbox(control.status);

    

end

