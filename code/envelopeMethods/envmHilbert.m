function [ env ] = envmHilbert( dataset, ~, params )
%ENVMHILBERT 

    sgolayWindow = floor(length(dataset) / params.windowsNumber) ;
    if sgolayWindow < params.minWindow
        sgolayWindow = params.minWindow;
    elseif mod(sgolayWindow,2)==0
        sgolayWindow = sgolayWindow + 1;
    end
    
    % filter (hilbert), take absolute values and smoothen (sgolay)
    env = sgolayfilt(abs(hilbert(dataset)), params.rank, sgolayWindow);

end