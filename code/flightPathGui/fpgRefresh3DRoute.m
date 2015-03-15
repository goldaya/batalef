function [  ] = fpgRefresh3DRoute(  )
%FPGREFRESH3DROUTE Summary of this function goes here
%   Detailed explanation goes here

    k = fpgGetCurrent();
    
    T = fileData(k, 'Calls', 'Times', 'Start', 'NoValidation', true);
    L = fileData(k, 'Calls', 'Locations', 'NoValidation', true);
    M = fileData(k, 'Mics','Positions','NoValidation',true);
    
    fpgPlotTrajectory(L,T,M);
    
end

