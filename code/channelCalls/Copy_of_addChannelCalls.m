function [  ] = addChannelCalls( k, j, M, replace, overwrite )
%ADDCHANNELCALLS Add calls to calls matrix of a channel
%   J = channel index in dataObject
%   M = matrix with new calls, can be of dimensions (n,2) or (n,11)
%       with columns:
%       1. detection point
%       2. detection value
%       3. peak point
%       4. peak value
%       5. peak frequency
%       6,7,8 - same as peak for start of call
%       9,10,11 - same as peak for end of call
%       12 - File call index
%       13 - ridge
%   (...,replace,...) = remove old data and add this new data 
%                       (default = 0 [no])   
%   (...,replace=false,overwrite) = overwrite existing rows with same peak 
%                                   point (default = 1 [yes] )

    global filesObject;

    validateFileChannelIndex(k,j);
    
    % default: overwrite = 1 [yes]
    if nargin < 3
        overwrite = 1;
    end
    
    % default: replace = 0 [no]
    if nargin <4
        replace = 0;
    end
    
    % handle new calls matrix (make it 11 columns matrix)
    [nrows, ncols] = size(M);
    switch ncols
        case 0
            nM = zeros(0,16);
        case 2
            nM = zeros(nrows, 16);
            nM(1:nrows,1:2) = M;
            
        case 16;
            nM = M;
        otherwise
            % error
            return;
    end
    
    channelCalls = filesObject(k).channels(j).channelCalls;
    if ~isempty(channelCalls)
        rc = channelCalls(:,13);
    else
        rc = cell(0);
    end
    
    % replace 
    if replace
        cm = nM;
        rc = cell(size(cm,1),1);
        
    % add new calls to existing matrix
    else
        
         if isempty(channelCalls)
            cm = nM;
            rc = cell(size(cm,1),1);
        else
            cm1 = cell2mat(filesObject(k).channels(j).channelCalls(:,1:12));
            for i = 1:nrows
                l = find(cm(1)==nM(i,1));
                if ~isempty(l) 
                    if overwrite
                        cm(l,:) = nM(i,:);
                        rc{l} = [];
                    end
                else
                    cm(size(cm,1)+1,:) = nM(i,:);
                    rc{size(cm,1)} = [];
                end;
            end
        end
    end
    
    % make cell array again
    s = size(cm);
    vrows = ones(s(1),1);
    vcols = ones(s(2),1);
    cc = mat2cell(cm,vrows,vcols);
    channelCalls = [cc,rc];
    
    % sort and put back in dataObject
    filesObject(k).channels(j).channelCalls = sortrows(channelCalls,1);
    


end