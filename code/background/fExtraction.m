function [  ] = fExtraction( K )
%FEXTRACTION Summary of this function goes here
%   Detailed explanation goes here
    global c;
    
    if isempty(K)
        return;
    end
    
    rawGapTolerance = getParam('callsGUI:gap')/1000;
    dbStart = getParam('callsGUI:dbStart');
    dbEnd = getParam('callsGUI:dbEnd');
    dt = getParam('callsGUI:callWindow')/1000 ; 
    
    % filter
    if logical(getParam('background:calls:filteredFE'))
        filterStr.method = c.butter; 
        filterStr.type = getParam('filter:butter:type');
        filterStr.f1 = getParam('filter:butter:f1').*1000;
        filterStr.f2 = getParam('filter:butter:f2').*1000;
        filterStr.order = getParam('filter:butter:order');
    else
        filterStr = [];
    end
    
    for k = 1:length(K)
       Fs = fileData(K(k),'Fs');
       gapTolerance = rawGapTolerance*Fs;
       for j = 1:fileData(K(k),'Channels','Count','NoValidation',true)
           dataset = channelData(K(k),j,'TS','Filter',filterStr);
           for s = 1:channelData(K(k),j,'Calls','Count','NoValidation',true)
               call = channelCall(K(k),j,s,'features',false);
                    
               window = [call.DetectionTime-dt/2, call.DetectionTime+dt/2];
               wip = channelCall.inPoints(call, window);
                    
               [call] = channelCallAnalyze(K(k),j,s,'features',window,dataset(wip(1):wip(2)),[],dbStart,dbEnd,gapTolerance,[],true,false);
               call.save( );
           end
       end
    end

end

