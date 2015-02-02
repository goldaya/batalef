function [ output_args ] = resample_i( k, p, q )
%RESAMPLE_I resample the raw data of a channel
%   see documantaion on "resample" function of matlab.

    global filesObject;
       
    % check p < q
    if p >= q
        return
    end
    
    % reduce p/q
    [p,q] = rat(p/q, 10^-2);
    
    
    % get data to resample
    TS = fileData(k,'TimeSeries');
    
    % resampled data:
    newData.nChannels = fileData(k,'nChannels');
    newData.Fs = ceil(fileData(k,'Fs')*p/q);
    newData.nSamples = ceil(fileData(k,'nSamples')*p/q);
    newData.data = zeros(newData.nSamples, newData.nChannels);
    newData.status = 'Decimated';
    
    for j = 1:newData.nChannels
        newData.data(:,j) = resample( TS(:,j), p, q);
    end
        
    
    % put the new raw data in stead of the old data
    filesObject(k).rawData = newData;

end

