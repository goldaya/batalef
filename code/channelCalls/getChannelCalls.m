function [ out1, out2, out3, out4 ] = getChannelCalls( k, j, varargin )

    global filesObject;
    
        out1 = [];
        out2 = [];
        out3 = [];
        out4 = [];
        
        par = varargin{1};
        
        switch par
            
            case 'Matrix'
                channelCalls = filesObject(k).channels(j).calls;
                if ~isempty(channelCalls)
                    detections = channelCalls.detection;
                    features = cell2mat(channelCalls.features(:,1:12));
                    out1 = [features,detections];
                else
                    out1 = [];
                end
                
            case 'ForLocalization'
                out1 = filesObject(k).channels(j).calls.forLocalization;
                
            case 'Ridge'
                out1 = filesObject(k).channels(j).calls.features(:,13);
                 
            case 'Count'
                out1 = size(filesObject(k).channels(j).calls.detection, 1);
                
            case 'Detections'
                I = getTimeInterval(k,varargin);
                if ~isempty(filesObject(k).channels(j).calls)
                    times  = filesObject(k).channels(j).calls.detection(:,1);
                    values = filesObject(k).channels(j).calls.detection(:,2);
                    indexes = 1:length(times);
                    
                    logicalA = times >= I(1);
                    logicalB = times <= I(2);
                    logicalI = logical(logicalA.*logicalB);
                    out1 = times(logicalI);
                    out2 = values(logicalI);
                    out3 = indexes(logicalI);
                end                
            case 'Peaks'
                if ~isempty(filesObject(k).channels(j).channelCalls)
                    out1 = cell2mat(filesObject(k).channels(j).channelCalls(:,3));
                    out2 = cell2mat(filesObject(k).channels(j).channelCalls(:,4));
                end
            
            case 'FileCalls'
                if ~isempty(filesObject(k).channels(j).channelCalls)
                    out1 = cell2mat(filesObject(k).channels(j).channelCalls(:,12));
                end
                
            case 'TS'
                n = getChannelCalls(k,j,'Count');
                out1 = cell(n,1);
                for s=1:n
                    [TS,T] = channelCallData(k,j,s,'TS');
                    out1{s} = [T,TS]; 
                end
                
            otherwise
                err = MException('bats:getChannelCalls:wrongParameter','The parameter "%s" is undefined for function "getChannelCalls"', par);
                throw(err);
        
        end
    
end
