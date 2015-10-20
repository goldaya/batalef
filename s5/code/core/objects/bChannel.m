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
        Fs
    end

    methods
        
        % CONSTRUCTOR
        function me = bChannel(fileobj,channelIdx)
            me.File = fileobj;
            me.j    = channelIdx;
        end
        
        % GET TS
        function [TS, T] = getTS(me,interval)
            [TS,T] = me.File.RawData.getTS(me.j,interval);
        end
        
        
        %%%%%%%%%
        % CALLS %
        %%%%%%%%%
        
        % GET CALLS COUNT
        function val = get.CallsCount(me)
            val = size(me.File.ChannelCalls{me.j}.detection,1);
        end
        
        % ADD CALLS DETECTION
        function addCallDetections(me,detection)
            me.addCalls(detection,[],{},[],[],{},{},{});
        end
        % ADD CALLS
        function addCalls(me,detection,features,ridge,forLocalization,forBeam,featuresAP, forLocalizationAP, forBeamAP)
            % detection is obligatory
            if isempty(detection)
                return;
            else
                n = size(detection,1);
            end
            
            % make sure all other fields have data
            m = 12;
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
            if isempty(featuresAP)
                featuresAP = cell(n,1);
            end
            if isempty(forLocalizationAP)
                forLocalizationAP = cell(n,1);
            end
            if isempty(forBeamAP)
                forBeamAP = cell(n,1);
            end            

            % add
            D = me.CallsData;
            n = n + size(D.detection,1);
            T.detection       = [D.detection;detection];
            T.features        = [D.features;features];
            T.forLocalization = [D.forLocalization;forLocalization];
            T.forBeam         = [D.forBeam;forBeam];
            T.ridge           = [D.ridge;ridge];
            T.featuresAP      = [D.featuresAP;featuresAP];
            T.forLocalizationAP  = [D.forLocalizationAP;forLocalizationAP];
            T.forBeamAP          = [D.forBeamAP;forBeamAP];
            
            % sort
            s = [T.detection(:,1),(1:n)'];
            s = sortrows(s);
            D.detection  = T.detection(s(:,2),:);
            D.features   = T.features(s(:,2),:);
            D.forLocalization ...
                         = T.forLocalization(s(:,2),:);
            D.forBeam    = T.forBeam(s(:,2),:);
            D.ridge      = T.ridge(s(:,2));
            D.featuresAP = T.featuresAP(s(:,2),:);
            D.forLocalizationAP ...
                         = T.forLocalizationAP(s(:,2),:);
            D.forBeamAP     = T.forBeamAP(s(:,2),:);            
            
            % put back in file data object
            me.CallsData = D;
        end

        % REMOVE CALLS
        function removeCallsByTimeInterval(me,timeInterval)
            D = me.CallsData;
            I = logical(( D.detection(:,1) > timeInterval(1) ) .* ( D.detection(:,1) < timeInterval(2) ));
            D.detection(I,:)       = [];
            D.features(I,:)        = [];
            D.ridge(I,:)           = [];
            D.forLocalization(I,:) = [];
            D.forBeam(I,:)         = [];
            D.featuresAP(I,:)      = [];
            D.forLocalizationAP(I,:)  = [];
            D.forBeamAP(I,:)          = [];
            me.CallsData = D;
        end
        function removeCallsByIndex(me, I)
            D = me.CallsData;
            D.detection(I,:)       = [];
            D.features(I,:)        = [];
            D.ridge(I,:)           = [];
            D.forLocalization(I,:) = [];
            D.forBeam(I,:)         = [];
            D.featuresAP(I,:)      = [];
            D.forLocalizationAP(I,:)  = [];
            D.forBeamAP(I,:)          = [];            
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
        
        % SET CALL DATA
        function setCallData(me,callIdx,detection,features,ridge,forLocalization,forBeam)
            D = me.CallsData;
            D.detection(callIdx,:) = detection;
            D.features(callIdx,:) = features;
            D.ridge{callIdx} = ridge;
            D.forLocalization(callIdx,:) = forLocalization;
            D.forBeam(callIdx,:) = forBeam;
            D.featuresAP{callIdx} = featuresAP;
            D.forLocalizationAP{callIdx} = forLocalizationAP;
            D.forBeamAP{callIdx} = forBeamAP;
            me.CallData = D;
        end
        
        % CALLS DATA GET/SET
        function val = get.CallsData(me)
            val = me.File.ChannelCalls{me.j};
        end
        function set.CallsData(me,val)
            me.File.ChannelCalls{me.j} = val;
        end
        
        % GET CALL OBJECT
        function c = call(me,callIdx)
            c = bChannelCall(me,callIdx);
        end
        
        %%%%%%%
        % POI %
        %%%%%%%
        
        % ADD POIS
        function addPois(me, C)
        %ADDPOIS add points of interest
        %   input has to be (N x 4) cell array with (time,text,amplitude,freq)
            P = me.PoiData;
            N = sortrows([P;C],1);
            me.PoiData = N;            
        end
        
        % REMOVE POIS BY TIME INTERVAL
        function removePoisByTime(me,timeInterval)
            P = me.PoiData;
            I1 = cellfun(@(t) t < timeInterval(1),P(:,1));
            I2 = cellfun(@(t) t > timeInterval(2),P(:,1));
            I = logical(I1+I2);
            N = P(I,:);
            me.PoiData = N;
            
        end
        
        % POI DATA GET/SET
        function val = get.PoiData(me)
            val = me.File.ChannelPoI{me.j};
        end
        function set.PoiData(me,val)
            me.File.ChannelPoI{me.j} = val;
        end

        %%%%%%%%%%%%%%%%%%%%%
        % GET DATA FUNCTION %
        %%%%%%%%%%%%%%%%%%%%%
        
        % GET DATA
        function varargout = getData(me, varargin)
            
            interval = getParFromVarargin('TimeInterval',varargin);
            if islogical(interval) && ~interval
                interval = [];
            end
            
            % get desired data
            switch varargin{1}
                case 'TS'
                    [TS,T] = me.File.RawData.getTS(me.j,interval);
                    varargout{1} = TS;
                    varargout{2} = T;
                    
                case 'PoI'
                    % [T,TXT,A,F]
                    D = me.PoiData;
                    P = getIntervalSubset(D,1,interval,true);
                    varargout{1} = [P{:,1}];
                    varargout{2} = P(:,2);
                    varargout{3} = [P{:,3}];
                    varargout{4} = [P{:,4}];
                case 'Calls'
                    
                    switch varargin{2}
                        case {'Detections','Detection'}
                            D = me.CallsData.detection;
                            [C,I] = getIntervalSubset(D,1,interval,false);
                            varargout{1} = C;
                            varargout{2} = I;    
                    end                    
            end
        end
        
        % FS
        function val = get.Fs(me)
            val = me.File.Fs;
        end
        
    end
end