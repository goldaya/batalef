function fcgReplaceLocations( D )
%FCGREPLACELOCATIONS INTERNAL Replace the locations of bat according to
%input
    
    global filesObject;
    k = fcgGetCurrent();
    
    % get the times to interpolate on
    times = fileData(k,'Calls','Times');
    Dt = D(:,1);
    if max(Dt) < max(times) || min(Dt) > min(times)
        msgbox('Interpolated time span is shorter than calls times span. Aborting.');
        return;
    end
    
    Dx = D(:,2);
    Dy = D(:,3);
    Dz = D(:,4);
    % interpolation
    Nx = spline(Dt,Dx,times);
    Ny = spline(Dt,Dy,times);
    Nz = spline(Dt,Dz,times);
    
    % keep
    n = fileData(k,'Calls','Count');
    for a = 1:n
        x = [Nx(a),Ny(a),Nz(a)];
        filesObject(k).fileCalls{a}.location = x;
        filesObject(k).fileCalls{a}.beam.powers = fileCallPowersMatrix(k,x,filesObject(k).fileCalls{a}.channelCalls);
    end
    
    % refresh calls table
    fcgPopulateCallsList();
    fcgPlotLocalization();
    fcgRefreshBeamPanel()

end

