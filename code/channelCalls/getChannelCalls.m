function [ out, add1, add2, add3 ] = getChannelCalls( k, j, varargin )

    global filesObject;
    
        out  = [];
        add1 = [];
        add2 = [];
        add3 = [];
        
        par = varargin{1};
        
        switch par
            
            case 'Matrix'
                channelCalls = filesObject(k).channels(j).channelCalls;
                if ~isempty(channelCalls)
                    out = cell2mat(channelCalls(:,1:12));
                else
                    out = [];
                end
                
            case 'Array'
                out = filesObject(k).channels(j).channelCalls;
            
            case 'Count'
                out = size(filesObject(k).channels(j).channelCalls, 1);
                
            case 'Detections'
                I = getSamplesInterval(k,varargin);
                if ~isempty(filesObject(k).channels(j).channelCalls)
                    points = cell2mat(filesObject(k).channels(j).channelCalls(:,1));
                    values = cell2mat(filesObject(k).channels(j).channelCalls(:,2));
                    times = points./channelData(k,j,'Fs','NoValidation',true);
                    indexes = 1:length(points);
                    
                    logicalA = points >= I(1);
                    logicalB = points <= I(2);
                    logicalI = logical(logicalA.*logicalB);
                    out = points(logicalI);
                    add1 = values(logicalI);
                    add2 = times(logicalI);
                    add3 = indexes(logicalI);
                end                
            case 'Peaks'
                if ~isempty(filesObject(k).channels(j).channelCalls)
                    out = cell2mat(filesObject(k).channels(j).channelCalls(:,3));
                    add1 = cell2mat(filesObject(k).channels(j).channelCalls(:,4));
                end
            
            case 'FileCalls'
                if ~isempty(filesObject(k).channels(j).channelCalls)
                    out = cell2mat(filesObject(k).channels(j).channelCalls(:,12));
                end
                
            case 'TS'
                n = getChannelCalls(k,j,'Count');
                out = cell(n,1);
                for s=1:n
                    [TS,T] = channelCallData(k,j,s,'TS');
                    out{s} = [T,TS]; 
                end
                
            case 'Ridge'
                out = filesObject(k).channels(j).channelCalls(:,13);
         
                
            otherwise
                err = MException('bats:getChannelCalls:wrongParameter','The parameter "%s" is undefined for function "getChannelCalls"', par);
                throw(err);
        
        end
    
end