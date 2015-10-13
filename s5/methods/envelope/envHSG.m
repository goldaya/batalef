function [ env ] = envHSG( dataset,~,params )
%ENVHSG Hilbert Savitzky Golay envelope

    sgolayWindow = floor(length(dataset) / params.windowsNumber) ;
    if sgolayWindow < params.minWindow
        sgolayWindow = params.minWindow;
    elseif sgolayWindow > params.maxWindow
        sgolayWindow = params.maxWindow;
    end
    if mod(sgolayWindow,2)==0
        sgolayWindow = sgolayWindow + 1;
    end
    
    % filter (hilbert), take absolute values and smoothen (sgolay)
    env = sgolayfilt(abs(hilbert(dataset)), params.rank, sgolayWindow);

end