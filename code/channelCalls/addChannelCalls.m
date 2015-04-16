function [  ] = addChannelCalls( k, j, M, replace )
%ADDCHANNELCALLS Add calls to calls matrix of a channel
%   k = file index
%   j = channel index in dataObject
%   M = matrix with new detection points
%   (...,replace,...) = remove old data and add this new data 
%                       (default = 0 [no])   

    validateFileChannelIndex(k,j);
    
    % replace 
    if nargin > 3 && replace
        channelCall.removeCalls(k,j,[]);
    end
        
    % add new calls to existing matrix
    channelCall.addCalls(k,j,M);


end