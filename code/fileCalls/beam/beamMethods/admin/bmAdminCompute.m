function [ IM, direction, width, power ] = bmAdminCompute( micPowers, micDirections )
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

    [IM, direction, width, power] = methodFunc(micPowers, micDirections, azCoors, elCoors, params);
    IM.image = IM;
    IM.azCoors = azCoors;
    IM.elCoors = elCoors;
    
end