function [  ] = removeChannelCalls( k, j, varargin )
%REMOVECHANNELCALLS Remove channel calls. this does not affect file
%calls

    global filesObject;
    
    % validateFileChannelIndex(k,j);
   
    % get channel calls matrix
    cc = filesObject(k).channels(j).channelCalls;
    if isempty(cc)
        return;
    end
    
    % criteria
    if ~isempty(varargin)
        for i = 1 : length(varargin)
            if ischar(varargin{i})
                switch varargin{i}
                    case {'all', 'All'}
                        cc = [];
                        break;

                    case 'DetectionIndex'
                        cc(varargin{i+1},:) = [];

                    case 'DetectionAfter'

                    case 'DetectionBefore'

                    case 'DetectionBetween'
                        if length(varargin{i+1})~=2
                            %error
                        end
                        cm = cell2mat(cc(:,1));
                        I = cm<varargin{i+1}(1) | cm(:,1)>varargin{i+1}(2);
                        cc = cc(I,:);

                end
            end
        end
    
    else % clear all
        cc = [];
    end
    
    filesObject(k).channels(j).channelCalls = cc;
end

