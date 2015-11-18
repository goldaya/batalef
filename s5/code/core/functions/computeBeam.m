function computeBeam(appobj,F,C,surfParams)
%COMPUTEBEAM Compute beam

    for k = 1:length(F)
        fileobj =  appobj.file(F(k));
        if isempty(C)
            Ci = 1:fileobj.CallsCount;
        else
            Ci = C;
        end
        for a = 1:length(Ci)
            cdata = fileobj.call(Ci(a));
            D = fileobj.getCallPowers(Ci(a));
            T = D{:,:};
            U = logical(T(:,1));
            P = T(U,size(T,2));
            M = fileobj.MicData.Positions;
            M = M(U,:);
            [d,w,i,surfImage] = appobj.Methods.fileCallBeam.execute(cdata.location,M,P,surfParams);
            cdata.beam.direction = d;
            cdata.beam.intensity = i;
            cdata.beam.width     = w;
            cdata.beam.surface.image      = surfImage;
            cdata.beam.surface.azRange    = surfParams.azRange;
            cdata.beam.surface.elRange    = surfParams.elRange;
            cdata.beam.surface.resolution = surfParams.res;
            cdata.beam.surface.zero       = surfParams.zero;
            fileobj.setCall(Ci(a),cdata);
        end
    end

end

