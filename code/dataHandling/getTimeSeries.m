function [ TS ] = getTimeSeries( k, samplesInterval, native )
%GETTIMESERIES Returns the TS from filesObject if exists, otherwise
%directly from file 
%INTERNAL ! use fileData(k,'TimeSeries') or channelData(k,j,'TimeSeries')
%for frontend use.
%
%   k = file index. 
    
    global filesObject;
    

    if ~exist('native', 'var') || ~native
        format = 'double';
    else
        format = 'native';
    end
    
  
    if isempty(filesObject(k).rawData.data)
        if ~promptFileReachable(k)
            err = MException('bats:rawData:fileUnreachable','The process depends on the content of an unreachable file');
            throw(err)
        end
        vers=version;
        vers=str2double(vers(1:3));
        if vers >= 8
            [TS]=audioread(fileData(k,'Fullpath'), samplesInterval, format );
        else
            [TS]=wavread( fileData(k,'Fullpath'), samplesInterval, format );
        end
    else
        TS = filesObject(k).rawData.data(samplesInterval(1):samplesInterval(2),:);
        if strcmp(format,'double');
            w = whos('TS');
            if ~strcmp(w.class,'double');
                TS = double(TS);
            end
        end
            
    end
    
    %{
    if ( samplesInterval(1) ~= samplesInterval(2) ) && ( size(TS,1)==1 )
        TS = transpose(TS);
    end
    %}
    
    if ~(samplesInterval(1) == samplesInterval(2))
        if (size(TS,1)==1)
            TS = transpose(TS);
        end
    end
    
end

