function [ fullpath ] = writeWavFile( K )
%WRITEWAVFILE Write a TS to a .wav file

    for i = 1:length(K)
        k = K(i);
        naked = fileData(k,'NakedName');
        ext   = fileData(k,'Extension');
        path  = fileData(k,'Path');

        secFile = strcat(path,naked,ext);
        [name,path] = uiputfile(secFile);
        if name
            Fs = fileData(k,'Fs');
            TS = fileData(k,'TS');
            fullpath = strcat( path, name );
            audiowrite( fullpath, TS, Fs );
        end
    end
end

