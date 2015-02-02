function [ callExists, hasCalls ] = changeChannelCall( k,j,s,varargin )
%CHANGECHANNELCALL Change values of specific channel-call
%   (k,j,s,'parameter1','value1',...)  = k is the file, j is the channel, s is the call
%   index.
%   parameters can be:  'startPoint','startValue','startFreq', same for the
%   end of call and peak, 'ridge' which is a matrix and 'lock' which is reserved.

    % check that call index is in limit
    hasCalls = false;
    callExists = false;
    global filesObject;
    if isempty(filesObject(k).channels(j).channelCalls)
        return;
    else
        hasCalls = true;
        if size(filesObject(k).channels(j).channelCalls, 1) < s
            return;
        end
        callExists = true;
        cv = filesObject(k).channels(j).channelCalls;
    end
    
    
    % put changes into call vector
    if length(varargin) < 2
        return;
    end
    for i = 1:length(varargin)-1
        if ischar(varargin{i})
            switch varargin{i}
                case 'DetectionPoint'
                    if isscalar(varargin{i+1})
                        cv{s,1} = varargin{i+1};
                    end     
                case 'DetectionValue'
                    if isscalar(varargin{i+1})
                        cv{s,2} = varargin{i+1};
                    end                     
                case 'StartPoint'
                    if isscalar(varargin{i+1})
                        cv{s,6} = varargin{i+1};
                    end
                case 'StartValue'
                    if isscalar(varargin{i+1})
                        cv{s,7} = varargin{i+1};
                    end                    
                case 'StartFreq'
                    if isscalar(varargin{i+1})
                        cv{s,8} = varargin{i+1};
                    end

                case 'PeakPoint'
                    if isscalar(varargin{i+1})
                        cv{s,3} = varargin{i+1};
                    end
                case 'PeakValue'
                    if isscalar(varargin{i+1})
                        cv{s,4} = varargin{i+1};
                    end                    
                case 'PeakFreq'
                    if isscalar(varargin{i+1})
                        cv{s,5} = varargin{i+1};
                    end
                    
                case 'EndPoint'
                    if isscalar(varargin{i+1})
                        cv{s,9} = varargin{i+1};
                    end
                case 'EndValue'
                    if isscalar(varargin{i+1})
                        cv{s,10} = varargin{i+1};
                    end                    
                case 'EndFreq'
                    if isscalar(varargin{i+1})
                        cv{s,11} = varargin{i+1};
                    end                    

                case 'Ridge'
                    cv{s,13} = varargin{i+1};

                case 'PeakPower'
                    if isscalar(varargin{i+1})
                        cv{s,14} = varargin{i+1};
                    end
                    
                case 'StartPower'
                    if isscalar(varargin{i+1})
                        cv{s,15} = varargin{i+1};
                    end
                case 'EndPower'
                    if isscalar(varargin{i+1})
                        cv{s,16} = varargin{i+1};
                    end
            end
        end
    end
    
    % put back in calls matrix
    filesObject(k).channels(j).channelCalls = cv;
    

end

