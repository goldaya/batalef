function [ metadata ] = readAudioMetadata( fullpath )
%READAUDIOMETADATA Read the audio metadata of an audio file
%   the audio signal itself is not saved

    vers=version;
    vers=str2double(vers(1));
    if vers >= 8
        A=audioinfo( fullpath );
        metadata.nChannels = A.NumChannels;
        metadata.nSamples = A.TotalSamples;
        metadata.Fs = A.SampleRate;
    else
        [data,Fs]=wavread( fullpath );
        s = size(data);
        metadata.nChannels = s(2);
        metadata.nSamples = s(1);
        metadata.Fs = Fs;
    end    

end

