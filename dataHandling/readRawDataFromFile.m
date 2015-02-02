function [ rawData ] = readRawDataFromFile( fullpath, withDataMatrix )
%READRAWDATAFROMFILE Read file info, and load/do not load TS matrix
    
    rawData = readAudioMetadata(fullpath);
    if withDataMatrix
        rawData.data = audioread(fullpath);
        rawData.status = 'Raw, Loaded';
    else
        rawData.data = [];
        rawData.status = 'Raw, Unloaded';
    end

end

