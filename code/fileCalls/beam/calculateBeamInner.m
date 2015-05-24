function interpolated = calculateBeamInner(k,a,micsBeamUsage,AZ,EL,Pm,Pg,Pd,Ps,withSave)

    global filesObject;
    
    
    U = logical(micsBeamUsage.*Pm);
    
    PsU = Ps(U);
    AZU = AZ(U);
    ELU = EL(U);
    
    [raw, interpolated, azCoors, elCoors] = bmAdminCompute( PsU, [AZU, ELU] );

    if withSave
        filesObject(k).fileCalls{a}.beam.micDirections    = [AZ,EL];
        filesObject(k).fileCalls{a}.beam.micsUsed         = micsBeamUsage;
        filesObject(k).fileCalls{a}.beam.powerRaw         = Pm;
        filesObject(k).fileCalls{a}.beam.powerAfterGain   = Pg;
        filesObject(k).fileCalls{a}.beam.powerAfterDirect = Pd;
        filesObject(k).fileCalls{a}.beam.power            = Ps;
        filesObject(k).fileCalls{a}.beam.raw              = raw;
        filesObject(k).fileCalls{a}.beam.coordinates      = [azCoors,elCoors];
        filesObject(k).fileCalls{a}.beam.interpolated     = interpolated;
    end
        
end