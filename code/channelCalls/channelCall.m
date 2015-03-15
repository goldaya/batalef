classdef channelCall < handle
    %CHANNELCALL Summary of this class goes here
    %   Detailed explanation goes here
    
    properties ( SetAccess = private )
       k
       j
       s
       Fs
       Lock
       Saved
       Ridge
       Spectrum
    end
       
    properties ( Access = private, Hidden = true )
       cDetection
       cStart
       cPeak
       cEnd        
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
       nPoints
       ipiPoints
       ipiTime
       MaxFreq
    end
    
    methods
        function me = channelCall(k,j,s)
            me.k = k;
            me.j = j;
            me.s = s;
            me.load();
            me.Fs = fileData(me.k, 'Fs');
            
        end
        
        function load(me)
            me.cDetection   = channelCallData(me.k, me.j, me.s, 'Detection');
            me.cStart       = channelCallData(me.k, me.j, me.s, 'Start');
            me.cPeak        = channelCallData(me.k, me.j, me.s, 'Peak');
            me.cEnd         = channelCallData(me.k, me.j, me.s, 'End');
            me.Ridge        = channelCallData(me.k, me.j, me.s, 'Ridge');
            
            % mark as saved / unsaved
            if me.cStart.Point==0
                me.Saved = false;
            else
                me.Saved = true;
            end
        end
        
        
        function save(me)
            changeChannelCall(me.k,me.j,me.s,...
                'StartPoint',me.cStart.Point, 'StartValue', me.cStart.Value, 'StartFreq', me.cStart.Freq,'StartPower',me.cStart.Power,...
                'PeakPoint', me.cPeak.Point, 'PeakValue', me.cPeak.Value, 'PeakFreq', me.cPeak.Freq,'PeakPower',me.cPeak.Power,...
                'EndPoint', me.cEnd.Point, 'EndValue', me.cEnd.Value, 'EndFreq', me.cEnd.Freq,'EndPower',me.cEnd.Power,...
                'Lock', me.Lock, 'Ridge', me.Ridge );                
            % mark as saved
            me.Saved = true;
        end
        
        function clearOldData(me)
            me.cStart.Point = [];
            me.cStart.Value = [];
            me.cStart.Freq = [];
            me.cStart.Power = [];
            me.cEnd.Point = [];
            me.cEnd.Value = [];
            me.cEnd.Freq = [];
            me.cEnd.Power = [];
            me.cPeak.Freq = [];
            me.cPeak.Power = [];
            me.Ridge = [];
            me.Spectrum.P = [];
            me.Spectrum.F = [];
        end
        
        function forceCallBoundries(me, startPoint, endPoint)
            % clean old data
            me.clearOldData();
            
            % set new bpundries
            me.cStart.Point = startPoint;
            me.cEnd.Point = endPoint;
            
            % get values and find peak
            dataset = channelData(me.k,me.j,'Envelope','Interval',[startPoint,endPoint]);
            me.cStart.Value = dataset(3);
            me.cEnd.Value = dataset(length(dataset)-3);
            [mval,argmax]=max(dataset);
            me.cPeak.Point = argmax + startPoint - 1;
            me.cPeak.Value = mval;
            
            % mark unsaved
            me.Saved = false;
        end
        
        function [peakPoint] = findPeak( me, callWindow, dataset )
            if isscalar(callWindow)
                dp = round( callWindow/1000 * me.Fs );
                a = round( me.cDetection.Point - dp/2 );
                b = round( me.cDetection.Point + dp/2 );
            else
                a = callWindow(1);
                b = callWindow(2);
            end
            if ~exist('dataset','var') || isempty(dataset)
                dataset = channelData(me.k, me.j, 'Envelope', [a,b]);
            end
            [valmax, argmax] = max(dataset);
            me.cPeak.Point = a + argmax;
            me.cPeak.Value = valmax;
            peakPoint = me.cPeak.Point;            
            % mark as unsaved
            me.Saved = false;
        end
        
        
        function [startPoint, endPoint] = realiseCallInterval(me, data, offset, startValue, endValue, gapTolerance )
            % clear old data
            me.clearOldData();
            % find start point
            peakPoint = me.cPeak.Point - offset;
            startPoint = peakPoint;
            gap = 0;
            for a=-peakPoint:-1
                i = -a;
                % if value is lower than threshold, take gap
                if data(i)<startValue
                    gap = gap + 1;
                else
                    startPoint = i;
                    gap = 0;
                end

                if gap > gapTolerance
                     break;
                end
            end
            me.cStart.Point = startPoint + offset;
            me.cStart.Value = data(startPoint);

            % find end point
            endPoint = peakPoint;
            gap = 0;
            for i=peakPoint:length(data)
                % if value is lower than threshold, take gap
                if data(i)<endValue
                    gap = gap + 1;
                else
                    endPoint = i;
                    gap = 0;
                end

                if gap > gapTolerance
                     break;
                end
            end
            me.cEnd.Point = endPoint + offset;
            me.cEnd.Value = data(endPoint);
            
            % mark as unsaved
            me.Saved = false;
        end
        
        function collectFromScreen(me)
            handles = pdgGetHandles();
            me.cStart.Point     = str2double(get(handles.textStartPoint, 'String'));
            me.cEnd.Point       = str2double(get(handles.textEndPoint, 'String'));
            me.Lock             = get(handles.cbLock, 'Value');
            me.cStart.Freq      = str2double(get(handles.textStartFreq, 'String'));
            me.cPeak.Freq       = str2double(get(handles.textPeakFreq, 'String'));
            me.cEnd.Freq        = str2double(get(handles.textEndFreq, 'String'));            
        end
        
        function [F,T,P,startT,endT] = computeSpectralData(me,callWindow)% window, overlap, nfft, callWindow)
            %ppad = round(padding/1000*me.Fs);
            a = callWindow(1);%max(0,me.cStart.Point-ppad);
            b = callWindow(2);%min(fileData(me.k,'nSamples'), me.cEnd.Point+ppad);
            dataset = channelData(me.k, me.j, 'TimeSeries', [a, b]);
            spec = somAdminCompute(dataset, me.Fs);
            T = spec.T;
            F = spec.F;
            P = spec.P;

            peakTime = me.cPeak.Point/me.Fs;
            startTime = me.StartTime;
            endTime = me.EndTime;
            T = T + (a/me.Fs);
            
            % get the closest coordinate to peak
            t1 = min(T(T>=peakTime));
            t2 = max(T(T<=peakTime));
            d1 = t1-peakTime;
            d2 = peakTime-t2;
            if isempty(t1)
                pP = P(:,T==t2);
            elseif isempty(t2)
                pP = P(:,T==t1);
            elseif d1 > d2
                pP = P(:,T==t2);
            else
                pP = P(:,T==t1);
            end
            
            % get the closest coordinate to start
            t1 = min(T(T>=startTime));
            t2 = max(T(T<=startTime));
            d1 = t1-startTime;
            d2 = startTime-t2;
            if isempty(t1)
                startT = t2;
            elseif isempty(t2)
                startT = t1;
            elseif d1 > d2
                startT = t2;
            else
                startT = t1;
            end
            sP = P(:,T==startT);
            
            % get the closest coordinate to end
            t1 = min(T(T>=endTime));
            t2 = max(T(T<=endTime));
            d1 = t1-endTime;
            d2 = endTime-t2;
            if isempty(t1)
                endT = t2;
            elseif isempty(t2)
                endT = t1;
            elseif d1 > d2
                endT = t2;
            else
                endT = t1;
            end
            eP = P(:,T==endT);
            
            
            % put highest freq in start/peak/end times
            [me.cPeak.Power, argmax] = max(pP);
            me.cPeak.Freq  = F(argmax); %F(pP==max(pP));
            [me.cStart.Power, argmax] = max(sP);
            me.cStart.Freq = F(argmax); %F(sP==max(sP));
            [me.cEnd.Power, argmax] = max(eP);
            me.cEnd.Freq   = F(argmax); %F(eP==max(eP));  
            
        end

        function [ridge] = computeRidge(me)
            try
                TSdataset = channelData(me.k, me.j, 'TS', [me.cStart.Point,me.cEnd.Point]);
                ridge = rdgmAdminCompute(TSdataset, me.Fs);
                ridge(:,1) = ridge(:,1) + me.StartTime;
            catch err
                err.message; % dummy line
                ridge = [];
            end
            me.Ridge = ridge;
        end
        
        function [P,F] = computeSpectrum(me)
            dataset = channelData(me.k, me.j, 'TimeSeries', [me.cStart.Point, me.cEnd.Point]);
            spec = sumAdminCompute(dataset,me.Fs);
            P = spec.P;
            F = spec.F;
            me.Spectrum.P = P;
            me.Spectrum.F = F;
        end
        
        % properties SET/GET
        function val = get.DetectionPoint(me)
            val = me.cDetection.Point;
        end
        function val = get.DetectionTime(me)
            val = me.cDetection.Point/me.Fs;
        end
        function val = get.DetectionValue(me)
            val = me.cDetection.Value;
        end
        function val = get.PeakPoint(me)
           val = me.cPeak.Point; 
        end
        function val = get.PeakTime(me)
            val = me.cPeak.Point/me.Fs;
        end
        function val = get.PeakValue(me)
            val = me.cPeak.Value;
        end
        function val = get.PeakFreq(me)
            val = me.cPeak.Freq;
        end
        function val = get.PeakPower(me)
            val = me.cPeak.Power;
        end        
        function val = get.StartPoint(me)
           val = me.cStart.Point; 
        end
        function val = get.StartTime(me)
            val = me.cStart.Point/me.Fs;
        end
        function val = get.StartValue(me)
            val = me.cStart.Value;
        end
        function val = get.StartFreq(me)
            val = me.cStart.Freq;
        end
        function val = get.StartPower(me)
            val = me.cStart.Power;
        end
        function val = get.EndPoint(me)
           val = me.cEnd.Point; 
        end
        function val = get.EndTime(me)
            val = me.cEnd.Point/me.Fs;
        end
        function val = get.EndValue(me)
            val = me.cEnd.Value;
        end
        function val = get.EndFreq(me)
            val = me.cEnd.Freq;
        end
        function val = get.EndPower(me)
            val = me.cEnd.Power;
        end
        function val = get.Saved(me)
            val = me.Saved;
        end
        function val = get.Lock(me)
            val = me.Lock;
        end        
        function val = get.Ridge(me)
            val = me.Ridge;
        end
        function out = get.MaxFreq(me)
            [out.P,argmax] = max(me.Spectrum.P);
            out.F = me.Spectrum.F(argmax);
        end
        
        function set.DetectionPoint(me, val)
            me.cDetection.Point = val;
        end
        function set.PeakPoint(me,val)
           me.cPeak.Point = val; 
        end
        function set.PeakValue(me,val)
            me.cPeak.Value = val;
        end
        function set.PeakFreq(me,val)
            me.cPeak.Freq = val;
        end
        function set.StartPoint(me,val)
           me.cStart.Point = val;
        end
        function set.StartValue(me,val)
            me.cStart.Value = val;
        end
        function set.StartFreq(me,val)
            me.cStart.Freq = val;
        end
        function set.EndPoint(me,val)
           me.cEnd.Point = val; 
        end
        function set.EndValue(me,val)
            me.cEnd.Value = val;
        end
        function set.EndFreq(me,val)
            me.cEnd.Freq = val;
        end   

        function set.Lock(me, val)
            me.Lock = val;
        end
        
        function val = get.Duration(me)
            val = (me.cEnd.Point - me.cStart.Point + 1)/me.Fs;
        end
        function val = get.nPoints(me)
            val = me.cEnd.Point - me.cStart.Point + 1;
        end
        function val = get.ipiPoints(me)
            if me.s == 1
                val = [];
            else
                lastCall = channelCall(me.k,me.j,me.s-1);
                val = me.cStart.Point - lastCall.StartPoint;
            end
        end
        function val = get.ipiTime(me)
            p = me.ipiPoints();
            val = p/me.Fs;
        end
        
    end
    
end

