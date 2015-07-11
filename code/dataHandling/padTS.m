function padTS( k,delta, atStart, atEnd, randomNoise )
%PADTS Add silence / random noise to start and/or end of TS

    global filesObject;
    
    % random noise not yet supported
    
    % make sure there is a dataset
    if isempty(filesObject(k).rawData.data)
        refreshRawData( k, true );
    end
    
    % pad
    rawData = filesObject(k).rawData;
    pointsDelta = round(delta * rawData.Fs);
    Z = zeros(pointsDelta,size(rawData.data,2));
    if atStart
        rawData.data = [Z;rawData.data];
        rawData.nSamples = rawData.nSamples + pointsDelta;
        for j = 1:fileData(k,'Channels','Count')
            channelCallsRetime(k,j,delta,false);
        end
        fileCallsRetime( k, delta, false );
    end
    
    if atEnd
        rawData.data = [rawData.data;Z];
        rawData.nSamples = rawData.nSamples + pointsDelta;
    end
    
    rawData.status = 'Altered';
    filesObject(k).rawData = [];
    filesObject(k).rawData = rawData;
    
    
end

