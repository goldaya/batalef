function fpgReplaceLocations( D )
%FPGREPLACELOCATIONS INTERNAL Replace the locations of bat according to
%input
    
    global filesObject;
    k = fpgGetCurrent();
    
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
        filesObject(k).fileCalls{a}.location = [Nx(a),Ny(a),Nz(a)];
    end
    
    
    % refresh calls table
    fpgRefreshFileCallsTable();
    fpgRefresh3DRoute()
    
    
    %{
    % check integrity of new data
    s = size(D);
    if s(2) == 3
        % OK
    elseif s(2) ~= 3 && s(1) == 3
        D = transpose(D);
        s = size(D);
    else
        errmsg = 'Replacing 3D locations: The new data is of a wrong size';
        throw(MException('bats:fileCalls:replaceLocations:wrongInput',errmsg));
    end
        
    % check number of calls in file and in new data is the same
    k = fpgGetCurrent();
    n = length(filesObject(k).fileCalls);
    if s(1) ~= n
        errmsg = 'Replacing 3D locations: The new data is of a wrong size';
        throw(MException('bats:fileCalls:replaceLocations:wrongInput',errmsg));
    end
    
    % Replace
    for a = 1:n
        filesObject(k).fileCalls{a}.location = D(a,:);
    end
    
    
    
    % refresh calls table
    fpgRefreshFileCallsTable();

    %}

end

