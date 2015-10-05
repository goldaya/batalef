function createMixFile( files, channels, filepath )
%CREATEMIXFILE Create a single audio file from mix of files

    global control;
    N  = length(files);
    TS = cell(1,N);
    FS = zeros(1,N);
    Files = control.app.Files(files);
    if appData('ParProc','Allowed')
        parfor i = 1:N
            [TS{i},FS(i)] = readFile4Mix(files(i),channels,Files{i});
        end
    else
        for i = 1:N
            [TS{i},FS(i)] = readFile4Mix(files(i),channels,Files{i});
        end        
    end
    
    if min(FS) ~= max(FS)
        errid  = 'batalef:files:mixFile:create:FsMismatch';
        errstr = 'The sampling rate varies in the selected files';
        err = MException(errid,errstr);
        throwAsCaller(err);
    end
    
    M = [];
    for i = 1:N
        try
            M = [M,TS{i}];
        catch err
            filterError(err,'MATLAB:catenate:dimensionMismatch');
            errid  = 'batalef:files:mixFile:create:nSamplesMismatch';
            errstr = 'The file length varies in the selected files';
            err = MException(errid,errstr);
            throwAsCaller(err);
        end
    end
    
    audiowrite( filepath, M, FS(1) ); 

end

function [TS,FS] = readFile4Mix(~,channels,File)

    TS = File.getData('TS','ChannelInterval',channels);
    FS = File.getData('Fs');

end

