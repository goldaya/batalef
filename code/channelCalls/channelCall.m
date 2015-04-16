classdef channelCall < handle
    %CHANNELCALL manipulating channel calls data (get/set, load/save ...)
    
    
    properties ( Constant )
       new       = 0;
       changed   = 1;
       unchanged = 2;
       unknown   = 3;
       features        = 4;
       forLocalization = 5;
       forBeam         = 6;
    end
    
    properties ( SetAccess = private, Hidden = true )
       k
       j
       s
       Fs
       TS % Time Signal Values
       T  % Time Signal Time-coordiantes
    end
       
    properties ( Access = public )
        Detection
        Start
        Peak
        End        
        Spectrum
        Ridge
        Status = channelCall.unknown;
        Type   = channelCall.unknown;
        IPI
        SpectralData
        Spectrograma
    end
    
    properties (Dependent)
        FileIdx
        ChannelIdx
        CallIdx
        DetectionTime
        DetectionValue
        PeakValue
        PeakTime
        PeakFreq
        PeakPower
        StartTime
        StartValue
        StartFreq
        StartPower
        EndValue
        EndTime
        EndFreq
        EndPower
        FileCall
        Duration
        MaxFreq
        TimeSignal
        Saved
    end
    
    methods (Static)
        
        function validateClass(obj)
            % raise exception if class differs from channelCall
            if ~isa(obj,'channelCall')
                err = MException('bats:classes:wrongClass','Use of class "channelCall" with wrong object type');
                throw(err)
            end
        end
        
        function val = inPoints(obj,time)
            % translate time coordinate into points coordinate
            % (approximation)
            channelCall.validateClass(obj);
            val = round(time.*obj.Fs);
        end
        
        function val = inTime(obj,points)
            % translate points coordinates into time
            channelCall.validateClass(obj);
            val = points.*obj.Fs;
        end
        
        function idx = addCalls(k,j,newCalls)
            global filesObject;
            
            newCalls = sortrows(newCalls);
            detections      = filesObject(k).channels(j).calls.detection;
            features        = filesObject(k).channels(j).calls.features;
            forLocalization = filesObject(k).channels(j).calls.forLocalization;
            forBeam         = filesObject(k).channels(j).calls.forBeam;
            
            n = size(detections,1);
            emptyCell = cell(1,13);
            idx = zeros(size(newCalls,1),1);
            for i = 1:size(newCalls,1)
                index = find(detections(:,1)>newCalls(i,1),1);
                if isempty(index)
                    idx(i) = n + 1;
                else
                    idx(i) = index;
                end
                
                % add call to detections matrix
                detections = [detections(1:idx(i)-1,:);newCalls(i,:);detections(idx(i):n,:)];
                
                % push features up
                features = [features(1:idx(i)-1,:);emptyCell;features(idx(i):n,:)];
                
                % push features for localiztion up
                forLocalization = [forLocalization(1:idx(i)-1,:);emptyCell;forLocalization(idx(i):n,:)];
                
                % push features for beam up
                forBeam = [forBeam(1:idx(i)-1,:);emptyCell;forBeam(idx(i):n,:)];
                
                %
                n = n + 1 ;
                
            end
            
            filesObject(k).channels(j).calls.detection       = detections;
            filesObject(k).channels(j).calls.features        = features;
            filesObject(k).channels(j).calls.forLocalization = forLocalization;
            filesObject(k).channels(j).calls.forBeam         = forBeam;
            
        end
        
        function removeCalls(K,J,M)
            % M == []        -> remove all calls
            % size(M,2) == 1 -> vector of indexes of calls to remove
            % size(M,2) == 2 -> time interval to clear of calls
            
            
            global filesObject;
            
            % resolve calls
            if ~exist('M','var')
                M = [];
            end
                       
            % resolve files to work on
            if ~exist('K','var') || isempty(K)
                K = 1:appData('Files','Count');
            end

            for k = 1:length(K)
                % resolve channels to work on
                N = fileData(K(k),'Channels','Count');
                if ~exist('J','var') || isempty(J)
                    Jk = 1:N;
                else
                    Jk = J(J<=N);
                end
            
                for j = 1:length(Jk)
                     
                    Sn = channelData(K(k),Jk(j),'Calls','Count');
                    calls = filesObject(K(k)).channels(Jk(j)).calls;
                    if isempty(M) % remove alll
                        calls.detection      = zeros(0,2);
                        calls.features        = cell(0,13);
                        calls.forLocalization = cell(0,13);
                        calls.forBeam         = cell(0,13);
                        
                    elseif size(M,2) == 1 % by index
                        I = M(M<Sn);
                        calls.detection(I,:)       = [];
                        calls.features(I,:)        = [];
                        calls.forLocalization(I,:) = [];
                        calls.forBeam(I,:)         = [];
                        
                    elseif size(M,2) == 2 % between times
                        I = 1:Sn;
                        I = I(logical((calls.detection(:,1)<=M(2)).*(calls.detection(:,1) >= M(1))));
                        calls.detection(I,:)       = [];
                        calls.features(I,:)        = [];
                        calls.forLocalization(I,:) = [];
                        calls.forBeam(I,:)         = [];                        
                    
                    end
                    filesObject(K(k)).channels(Jk(j)).calls = calls;
                
                end

            end
        end
        
    end
    
    methods (Hidden = true)
        function val = evalu(me,str)
            val = eval(str);
        end
    end
    
    methods (Access = public)
        % constructor
        function me = channelCall(k,j,s,type,empty)
            me.k    = k;
            me.j    = j;
            me.s    = s;
            me.Type = type;
            me.Fs = fileData(me.k, 'Fs');
            
            % detection
            me.Detection.Time  = 0;
            me.Detection.Value = 0;
            
            % start
            me.Start.Time  = 0;
            me.Start.Value = 0;
            me.Start.Freq  = 0;
            me.Start.Power = 0;
            
            % peak
            me.Peak.Time  = 0;
            me.Peak.Value = 0;
            me.Peak.Freq  = 0;
            me.Peak.Power = 0;
            
            % end
            me.End.Time  = cv{ 9};
            me.End.Value = cv{10};
            me.End.Freq  = cv{11};
            me.End.Power = cv{12};            
            
            % ridge
            me.Ridge = cv{13};            
            
            if s == 0
                me.Status = channelCall.new;
            elseif empty
                me.Status = channelCall.unknown;
            else
                me.load();
            end
            
        end
        
        function load(me)
            % load call data from global structures
            global filesObject;
            
            if me.Status == me.new
                return;
            end
            
            try
                dv = filesObject(me.k).channels(me.j).calls.detection(me.s,:);
                cv = filesObject(me.k).channels(me.j).calls.(me.Type)(me.s,:);
            catch err
                me.Status = me.new;
                return;
            end
            
            % status
            me.Status = me.unchanged;
            
            % detection
            me.Detection.Time  = dv(1);
            me.Detection.Value = dv(2);
            
            % start
            me.Start.Time  = cv{1};
            me.Start.Value = cv{2};
            me.Start.Freq  = cv{3};
            me.Start.Power = cv{4};
            
            % peak
            me.Peak.Time  = cv{5};
            me.Peak.Value = cv{6};
            me.Peak.Freq  = cv{7};
            me.Peak.Power = cv{8};            
            
            % end
            me.End.Time  = cv{ 9};
            me.End.Value = cv{10};
            me.End.Freq  = cv{11};
            me.End.Power = cv{12};            
            
            % ridge
            me.Ridge = cv{13};

            % IPI - should improve this method
            if me.s == 1 || me.Status == me.new
                me.IPI = [];
            else
                lastCall = channelCall(me.k,me.j,me.s-1);
                me.IPI = me.Start.Time - lastCall.StartTime;
            end            
        end
        
        function loadTS(me)
            % load TimeSignal of call into object's internal data
            [me.TS, me.T] = channelData(me.k,me.j,'TimeSeries',me.inPoints(me,[me.Start.Time, me.End.Time]));
        end
        
        
        function save(me)
            % save data to global structures
            
            if me.Status == me.unchanged
                return;
            end
            
            global filesObject;
    
            % add call when new
            if me.Status == me.new
                S = channelCall.addCalls([me.Detection.Time, me.Detection.Value]);
                me.s = S(1);
            end
            
            % build data structures
            dv = cell(1,2);
            cv = cell(1,13);
            dv{ 1} = me.Detection.Time;
            dv{ 2}  = me.Detection.Value;
            cv{ 1} = me.Start.Time;
            cv{ 2}  = me.Start.Value;
            cv{ 3}  = me.Start.Freq;
            cv{ 4} = me.Start.Power;
            cv{ 5} = me.Peak.Time;
            cv{ 6}  = me.Peak.Value;
            cv{ 7}  = me.Peak.Freq;
            cv{ 8} = me.Peak.Power;
            cv{ 9} = me.End.Time;
            cv{10} = me.End.Value;
            cv{11} = me.End.Freq;
            cv{12} = me.End.Power;
            cv{13} = me.Ridge;
            
            % save
            filesObject(me.k).channels(me.j).calls.detection(me.s,:) = dv;
            filesObject(me.k).channels(me.j).calls.(me.Type)(me.s,:) = cv;
            
            % set status
            me.Status = me.unchanged;
            
        end

        function remove(me)
            % remove file call associated with this channel call
            if me.FileCall ~= 0
                deleteFileCall(me.k,me.FileCall);
                % should change this after developing file calls objects
            end
            
            % reindex later channel calls in file calls
            % to be developed after file call objects.
            
            % remove call from global structure, by call index
            global filesObject;
            filesObject(me.k).channels(me.j).calls.detection(me.s,:)       = [];
            filesObject(me.k).channels(me.j).calls.features(me.s,:)        = [];
            filesObject(me.k).channels(me.j).calls.forLocalization(me.s,:) = [];
            filesObject(me.k).channels(me.j).calls.forBeam(me.s,:)         = [];
            
            
            me.Status = me.new;
        end
        
    end
    
    
    % properties SET/GET
    methods
        
        % indexes
        function val = get.FileIdx(me)
            val = me.k;
        end
        function val = get.ChannelIdx(me)
            val = me.j;
        end
        function val = get.CallIdx(me)
            val = me.s;
        end
        
        % detection time
        function val = get.DetectionTime(me)
            val = me.Detection.Time;
        end
        function set.DetectionTime(me, val)
            if me.Detection.Time ~= val
                me.Detection.Time = val;
                me.Status = me.changed;
            end
        end
        
        % detection value (envelope value)
        function val = get.DetectionValue(me)
            val = me.Detection.Value;
        end
        function set.DetectionValue(me,val)
            if me.Detection.Value ~= val
                me.Detection.Value = val;
                me.Status = me.changed;
            end
        end
        
        % peak time
        function val = get.PeakTime(me)
            val = me.Peak.Time;
        end
        function set.PeakTime(me,val)
            if me.Peak.Time ~= val
                me.Peak.Time = val;
                me.Status = me.changed;
            end
        end
        
        % peak value
        function val = get.PeakValue(me)
            val = me.Peak.Value;
        end
        function set.PeakValue(me,val)
            if me.Peak.Value ~= val
                me.Peak.Value = val;
                me.Status = me.changed;
            end
        end
        
        % peak frequency
        function val = get.PeakFreq(me)
            val = me.Peak.Freq;
        end
        function set.PeakFreq(me,val)
            if me.Peak.Freq ~= val
                me.Peak.Freq = val;
                me.Status = me.changed;
            end
        end
        
        % peak power
        function val = get.PeakPower(me)
            val = me.Peak.Power;
        end        
        function set.PeakPower(me,val)
            if me.Peak.Power ~= val
                me.Peak.Power = val;
                me.Status = me.changed;
            end
        end           
        
        % start time
        function val = get.StartTime(me)
            val = me.Start.Time;
        end
        function set.StartTime(me,val)
            if me.Start.Time ~= val
                me.Start.Time = val;
                me.Status = me.changed;
            end
        end
        
        % start value
        function val = get.StartValue(me)
            val = me.Start.Value;
        end
        function set.StartValue(me,val)
            if me.Start.Value ~= val
                me.Start.Value = val;
                me.Status = me.changed;
            end
        end
        
        % start frequency
        function val = get.StartFreq(me)
            val = me.Start.Freq;
        end
        function set.StartFreq(me,val)
            if me.Start.Freq ~= val
                me.Start.Freq = val;
                me.Status = me.changed;
            end
        end
        
        % start power
        function val = get.StartPower(me)
            val = me.Start.Power;
        end
        function set.StartPower(me,val)
            if me.Start.Power ~= val
                me.Start.Power = val;
                me.Status = me.changed;
            end
        end           
        
        % end time
        function val = get.EndTime(me)
            val = me.End.Time;
        end
        function set.EndTime(me,val)
            if me.End.Time ~= val
                me.End.Time = val;
                me.Status = me.changed;
            end
        end
        
        % end value
        function val = get.EndValue(me)
            val = me.End.Value;
        end
        function set.EndValue(me,val)
            if me.End.Value ~= val
                me.End.Value = val;
                me.Status = me.changed;
            end
        end
        
        % end frequency
        function val = get.EndFreq(me)
            val = me.End.Freq;
        end
        function set.EndFreq(me,val)
            if me.End.Freq ~= val
                me.End.Freq = val;
                me.Status = me.changed;
            end
        end   
        
        % end power
        function val = get.EndPower(me)
            val = me.End.Power;
        end
        function set.EndPower(me,val)
            if me.End.Power ~= val
                me.End.Power = val;
                me.Status = me.changed;
            end
        end   
        
        % File Call
        function val = get.FileCall(me)
            val = getFileCall4ChannelCall(me.k,me.j,me.s);
        end
        
        % maximal frequency
        function out = get.MaxFreq(me)
            [out.P,argmax] = max(me.Spectrum.P);
            out.F = me.Spectrum.F(argmax);
        end
        
        % duration of call
        function val = get.Duration(me)
            val = me.End.Time - me.Start.Time;
        end

        % Time Signal
        function val = get.TimeSignal(me)
            if isempty(me.TS)
                me.loadTS();
            end
            val = [me.T, me.TS];
        end
        
        % Saved
        function val = get.Saved(me)
            if me.Status == me.unchanged
                val = true;
            else
                val= false;
            end
        end
        
    end
    
end