classdef channelCall < handle
    %CHANNELCALL manipulating channel calls data (get/set, load/save ...)
    
    
    properties ( Constant )
       new       = 0;
       changed   = 1;
       unchanged = 2;
       unknown   = 3;
       featuresExtraction = 4;
       forLocalization    = 5;
       forBeamComputation = 6;
    end
    
    properties ( SetAccess = private, Hidden = true )
       k
       j
       s
       Fs
    end
       
    properties ( Access = public )
        Detection
        Start
        Peak
        End        
        Spectrum
        Ridge
        TS
        Status = me.unknown;
        Type   = me.unknown;
        IPI
    end
    
    properties (Dependent)
        DetectionPoint
        DetectionTime
        DetectionValue
        PeakPoint
        PeakValue
        PeakTime
        PeakFreq
        PeakPower
        StartPoint
        StartTime
        StartValue
        StartFreq
        StartPower
        EndPoint
        EndValue
        EndTime
        EndFreq
        EndPower
        Duration
        MaxFreq
    end
    
    methods (Static)
        function val = getDetection(k,j,s)
            global filesObject;
        end
    end
    
    methods
        function me = channelCall(k,j,s,type,empty)
            me.k    = k;
            me.j    = j;
            me.s    = s;
            me.Type = type;
            if ~empty
                me.load();
            end
            me.Fs = fileData(me.k, 'Fs');
            
        end
        
        function load(me)
        end
        
        
        function save(me)
        end

        function remove(me)
        end
        
        % properties SET/GET
        function val = get.DetectionPoint(me)
        end
        function val = get.DetectionTime(me)
            val = me.Detection.Time;
        end
        function val = get.DetectionValue(me)
            val = me.Detection.Value;
        end
        function val = get.PeakPoint(me)
        end
        function val = get.PeakTime(me)
            val = me.Peak.Time;
        end
        function val = get.PeakValue(me)
            val = me.Peak.Value;
        end
        function val = get.PeakFreq(me)
            val = me.Peak.Freq;
        end
        function val = get.PeakPower(me)
            val = me.Peak.Power;
        end        
        function val = get.StartPoint(me)
        end
        function val = get.StartTime(me)
            val = me.Start.Time;
        end
        function val = get.StartValue(me)
            val = me.Start.Value;
        end
        function val = get.StartFreq(me)
            val = me.Start.Freq;
        end
        function val = get.StartPower(me)
            val = me.Start.Power;
        end
        function val = get.EndPoint(me)
        end
        function val = get.EndTime(me)
            val = me.End.Time;
        end
        function val = get.EndValue(me)
            val = me.End.Value;
        end
        function val = get.EndFreq(me)
            val = me.End.Freq;
        end
        function val = get.EndPower(me)
            val = me.End.Power;
        end
        function out = get.MaxFreq(me)
            [out.P,argmax] = max(me.Spectrum.P);
            out.F = me.Spectrum.F(argmax);
        end
        
        function set.DetectionTime(me, val)
            me.Detection.Time = val;
        end
        function set.PeakPoint(me,val)
           me.Peak.Time = val; 
        end
        function set.PeakValue(me,val)
            me.Peak.Value = val;
        end
        function set.PeakFreq(me,val)
            me.Peak.Freq = val;
        end
        function set.StartTime(me,val)
           me.Start.Time = val;
        end
        function set.StartValue(me,val)
            me.Start.Value = val;
        end
        function set.StartFreq(me,val)
            me.Start.Freq = val;
        end
        function set.EndTime(me,val)
           me.End.Time = val; 
        end
        function set.EndValue(me,val)
            me.End.Value = val;
        end
        function set.EndFreq(me,val)
            me.End.Freq = val;
        end   

        function val = get.Duration(me)
            val = me.End.Time - me.Start.Time;
        end

        function val = get.IPI(me)
            if me.s == 1
                val = [];
            else
                % this call start - last call start
            end
        end
        
    end
    
end