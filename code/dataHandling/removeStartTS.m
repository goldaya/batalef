function [ channelCallsSubzero, fileCallsSubzero ] = removeStartTS( k, delta, testrun )
%REMOVESTARTTS Remove a delta from the beginning of the Time Signal

    global filesObject;
    
  
    % Re time channel calls
    channelCallsSubzero = false;
    for j = 1:fileData(k,'Channels','Count');
         subzero = channelCallsRetime( k, j, -delta, testrun );
         if subzero
            channelCallsSubzero = true;
         end
    end
    
    % Re time file calls
    fileCallsSubzero = fileCallsRetime(k,-delta,testrun);
    
    % thats it for test run
    if testrun
        return;
    end
    
    % load TS to memory if absent
    if isempty(filesObject(k).rawData.data)
        refreshRawData( k, true );
    end
    
    % cut TS
    pointsDelta = round(delta * fileData(k,'Fs'));
    rawData = filesObject(k).rawData;
    rawData.data = rawData.data(pointsDelta+1:rawData.nSamples,:);
    rawData.nSamples = rawData.nSamples - pointsDelta;
    rawData.status = 'Altered';
    
    filesObject(k).rawData = [];
    filesObject(k).rawData = rawData;
    
end

