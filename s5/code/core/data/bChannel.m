classdef bChannel < handle

    properties (Access = private)
        File
        j
    end

    properties (Dependent = true, Hidden = true)
        CallsData
        PoiData
    end

    properties (Dependent = true)
        CallsCount
        CallsMatrix
        CallsRidges
    end

    methods
        % CONSTRUCTOR
        function me = bChannel(fileobj,channelIdx)
            me.File = fileobj;
            me.j    = channelIdx;
        end

        % GET CALLS COUNT
        function val = get.CallsCount(me)
            val = size(me.File.ChannelCalls{me.j}.detection,1);
        end
        
        % ADD CALLS
        function addCalls(me,detection,features,ridge,forLocalization,forBeam)
            % detection is obligatory
            if isempty(detection)
                return;
            else
                n = size(detection,1);
            end
            
            % make sure all other fields have data
            m = 13;
            if isempty(features)
                features = zeros(n,m);
            end
            if isempty(forLocalization)
                forLocalization = zeros(n,m);
            end
            if isempty(forBeam)
                forBeam = zeros(n,m);
            end
            if isempty(ridge)
                ridge = cell(n,1);
            end

            % add
            D = me.CallsData;
            n = n + size(D.detection,1);
            T.detection = [D.detection;detection];
            T.features  = [D.features;features];
            T.forLocalization ...
                        = [D.forLocalization;forLocalization];
            T.forBeam   = [D.forBeam;forBeam];
            T.ridge     = [D.ridge;ridge];
            
            % sort
            s = [T.detection(:,1),[1:n]'];
            s = sortrows(s);
            D.detection = T.detection(s(:,2),:);
            D.features  = T.features(s(:,2),:);
            D.forLocalization ...
                        = T.forLocalization(s(:,2),:);
            D.forBeam   = T.forBeam(s(:,2),:);
            D.ridge     = T.ridge(s(:,2),:);
            
            % put back in file data object
            me.CallsData = D;
        end

        % REMOVE CALLS
        function removeCallsByTimeInterval(me,timeInterval)
            D = me.CallsData;
            I = logical(( D.detection(:,1) < timeInterval(1) ) .* ( D.detection(:,1) > timeInterval(2) ));
            D.detection(I,:)       = [];
            D.features(I,:)        = [];
            D.ridge(I,:)           = [];
            D.forLocalization(I,:) = [];
            D.forBeam(I,:)         = [];
            me.CallsData = D;
        end
        function removeCallsByIndex(me, I)
            D = me.CallsData;
            D.detection(I,:)       = [];
            D.features(I,:)        = [];
            D.ridge(I,:)           = [];
            D.forLocalization(I,:) = [];
            D.forBeam(I,:)         = [];
            me.CallsData = D;            
        end
        
        % BUILD CALLS MATRIX
        function M = get.CallsMatrix(me)
            D = me.CallsData;
            M = [D.detection,D.features,D.forLocalization,D.forBeam];
        end
        
        % GET RIDGES
        function R = get.CallsRidges(me)
            R = me.CallsData.ridge;
        end
        
        function setCallData(me,callIdx,detection,features,ridge,forLocalization,forBeam)
            D = me.CallsData;
            D.detection(callIdx,:) = detection;
            D.features(callIdx,:) = features;
            D.ridge(callIdx,:) = ridge;
            D.forLocalization(callIdx,:) = forLocalization;
            D.forBeam(callIdx,:) = forBeam;
            me.CallData = D;
        end
        
        % GET HIDDEN DATA
        function val = get.CallsData(me)
            val = me.File.ChannelCalls{me.j};
        end
        function set.CallsData(me,val)
            me.File.ChannelCalls{me.j} = val;
        end
        function val = get.PoiData(me)
            val = me.File.ChannelPoI{me.j};
        end
        
        
        % GET DATA
        function varargout = getData(me, varargin)
            
            interval = getParFromVarargin('TimeInterval',varargin);
            if islogical(interval) && ~interval
                interval = [];
            end
            
            % get deisred data
            switch varargin{1}
                case 'TS'
                    [TS,T] = me.File.RawData.getTS(me.j,interval);
                    varargout{1} = TS;
                    varargout{2} = T;
            end
        end
    end
end
