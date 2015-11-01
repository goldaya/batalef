function ok = setMicData( app, files, N, position, gain, uMatch, uLocal, uBeam, dManage, dTable, dZero )
%SETMICDATA Set mic data for files

    ok = arrayfun(@(f) setMicDataFile(app,f,N,position,gain,uMatch,uLocal,uBeam,dManage,dTable,dZero),files);

end

function ok = setMicDataFile( app, k, N, position, gain, uMatch, uLocal, uBeam, dManage, dTable, dZero )
    m = app.file(k).MicData;
    if m.N ~= N
        ok = false;
    else
        try
            m.Positions         = position;
            m.GainVector        = gain;
            m.Directionality.Manage = dManage;
            m.setDirectionalityData(dTable)
            m.Directionality.Zero   = dZero;
            m.UseInMatching     = uMatch;
            m.UseInLocalization = uLocal;
            m.UseInBeam         = uBeam;
            ok = true;
        catch err
            disp(err.message);
            ok = false;
        end
    end
end