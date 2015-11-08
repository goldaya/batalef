function [ok, t, x, seq] = matchAndAddFileCall( app,file,baseChannel,baseCall )
%MATCHANDADDFILECALL find match (of channel calls) for a file call,
%localize, find time, and save into data structure

    if isa(file,'bFile')
        fileObj = file;
    elseif isnumeric(file)
        fileObj = app.file(file);
    else
        errid = 'batalef:fileCalls:matching:wrongInput';
        errstr = '"file" should be either a bFile object or the file index';
        throwAsCaller(MException(errid,errstr));
    end
    
    % match
    [seq,T] = app.Methods.fileCallsMatching.execute(fileObj,baseChannel,baseCall);
    seq(isnan(seq))=0;
    
    % localize
    M = fileObj.MicData.Positions;
    U = logical(fileObj.MicData.UseInLocalization .* seq'~=0);
    Tl = T(U);
    Ml = M(U,:);
    [x,t] = app.Methods.fileCallLocalization.execute(Tl,Ml,agetParam('defaultSoundSpeed'),struct());
    
    % add to data structures
    if ~isempty(x) && ~isempty(t)
        fileObj.addCall(seq,t,x);
        ok = true;
    else
        ok  = false;
    end

end

