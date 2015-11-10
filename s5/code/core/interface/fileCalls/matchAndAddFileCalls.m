function ok = matchAndAddFileCalls( app,file )
%MATCHANDADDFILECALLS find match (of channel calls) for file calls,
%localize, find time, and save into data structure, or all possible calls
%in a file

    if isa(file,'bFile')
        fobj = file;
    elseif isnumeric(file)
        fobj = app.file(file);
    else
        errid = 'batalef:fileCalls:matching:wrongInput';
        errstr = '"file" should be either a bFile object or the file index';
        throwAsCaller(MException(errid,errstr));
    end
    
    % set base: use best SNR channel and start with first channel call
    J = 1:fobj.ChannelsCount;
    U = fobj.MicData.UseInLocalization;
    J = J(U);
    SNR = arrayfun(@(j)snr(fobj.channel(j).getTS([])),J);
    [~,bestSNR] = max(SNR);
    j = J(bestSNR);
    s = 1;
    if j == 0 || s == 0
        ok = false;
        return;
    end
    
    % match
    ok = false;
    passed = false(fobj.ChannelsCount,1);
    while j > 0
        okw = matchAndAddFileCall(app,fobj,j,s);
        [ j2,s ] = getNextBase(fobj,j,s);
        if j2 ~= j
            if passed(j2)
                break;
            end
            passed(j) = true;
            j = j2;
        end
        ok = max(ok,okw);
    end


end

