function [ channelCallsPostend, fileCallsPostend ] = removeEndTS( k, delta, testrun )
%REMOVEENDTS Remove a delta from the End of the Time Signal

    global filesObject;
    
    oldEnd = fileData(k,'Length');
    newEnd = oldEnd - delta;
    
    % remove calls
    channelCallsPostend = channelCall.removeCalls(k,[],[newEnd,oldEnd],testrun);
    fileCallsPostend    = fileCall.removeCalls(k,[newEnd,oldEnd],testrun);
    
    if testrun
        return;
    end
    
    % remove end
    % load TS to memory if absent
    if isempty(filesObject(k).rawData.data)
        refreshRawData( k, true );
    end
    
    % cut TS
    pointsDelta = round(newEnd * fileData(k,'Fs'));
    rawData = filesObject(k).rawData;
    rawData.data = rawData.data(1:pointsDelta,:);
    rawData.nSamples = pointsDelta;
    rawData.status = 'Altered';
    
    filesObject(k).rawData = [];
    filesObject(k).rawData = rawData;


end

