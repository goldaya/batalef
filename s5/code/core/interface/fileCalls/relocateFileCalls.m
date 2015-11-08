function [ok,ret] = relocateFileCalls( app,filesVector,knownPath )
%RELOCATEFILECALLS Relocate file calls based on a given known path (from
%camera data for example)

    ret = arrayfun(@(f)relocate(app.file(f),knownPath),filesVector,'UniformOutput',false);
    ok = min(cellfun(@(r)r.ok,ret));

end

function ret = relocate(fobj,D)
    
    % get the times to interpolate on
    T = fobj.getCallsTable(false);
    if isempty(T)
        return; % nothing to do
    end
    
    times = T{:,1};
    Dt = D(:,1);
    if max(Dt) < max(times) || min(Dt) > min(times)
        ret.ok = false;
        ret.msg = 'Interpolated time span is shorter than calls times span. Aborting.';
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
    for a = 1:fobj.CallsCount
        fobj.Calls(a).location = [Nx(a),Ny(a),Nz(a)];
    end
    
    % return code
    ret.ok = true;
    ret.msg = '';


end
