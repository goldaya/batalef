function [  ] = addChannelCalls( k, j, M, replace, overwrite )
%ADDCHANNELCALLS Add calls to calls matrix of a channel
%   J = channel index in dataObject
%   M = matrix with new detection points
%   (...,replace,...) = remove old data and add this new data 
%                       (default = 0 [no])   
%   (...,replace=false,overwrite) = overwrite existing rows with same peak 
%                                   point (default = 1 [yes] )

    global filesObject;

    validateFileChannelIndex(k,j);
    
    % default: overwrite = 1 [yes]
    if nargin < 5
        overwrite = 1;
    end
    
    % default: replace = 0 [no]
    if nargin <4
        replace = 0;
    end
    
  
    channelCalls = filesObject(k).channels(j).channelCalls;
    n = size(M,1);
    if n==0
        return; % nothing to do
    end
    
    % replace 
    if replace || isempty(channelCalls)
        channelCalls = num2cell([M,zeros(n,11),NaN(n,1),zeros(n,3)]);
        
    % add new calls to existing matrix
    else
        detPoints = cell2mat(channelCalls(:,1));
        for i = 1:n
            newCall = num2cell([M(i,:),zeros(1,11),NaN(1,1),zeros(1,3)]);
            l = find(detPoints==M(i,1));
            if ~isempty(l) 
                if overwrite
                    channelCalls(l,:) = newCall;
                end
            else
                channelCalls(size(channelCalls,1)+1,:) = newCall;
            end;
        end
    end
    
    
    % sort and put back in dataObject
    [~,I] = sort(cell2mat(channelCalls(:,1)));
    filesObject(k).channels(j).channelCalls = channelCalls(I,:);
    


end