function [ raw, interpolated, azCoors, elCoors ] = bmAdminCompute( powers, micDirections )
%BMADMINCOMPUTE Compute beam by selected method

    global control;
    method = control.beam.method;
    params = control.beam.params;
    beamMethods;
    
    if length(m)< method
        return; % should provide error
    end
    
    methodFunc = str2func(m{method}{2});
    
    domain.azMin = getParam('beam:minAz');
    domain.azMax = getParam('beam:maxAz');
    domain.elMin = getParam('beam:minEl');
    domain.elMax = getParam('beam:maxEl');
    domain.azRes = getParam('beam:resAz');
    domain.elRes = getParam('beam:resEl');
    azCoors = transpose(linspace(domain.azMin,domain.azMax,round((domain.azMax - domain.azMin)/domain.azRes)));
    elCoors = transpose(linspace(domain.elMin,domain.elMax,round((domain.elMax - domain.elMin)/domain.elRes)));
    clear domain;
    [raw, interpolated] = methodFunc(powers, micDirections, azCoors, elCoors, params);   
    
end