function call = channelCallComputeSpectralData( call, dataset, Fs, callStartPoint, callEndPoint )
%CHANNELCALLCOMPUTESPECTRALDATA

        
        T = call.Spectrograma.T;
        F = call.Spectrograma.F;
        P = call.Spectrograma.P;
        
       
        % stats
        % find principle frequency at start, peak, end: get the closest
        % coordinate to start/peak/end, and then take max on the spectrogram
        % slice

        % peak
        t1 = min(T(T>=call.PeakTime));
        t2 = max(T(T<=call.PeakTime));
        d1 = t1-call.PeakTime;
        d2 = call.PeakTime-t2;
        if isempty(t1)
            pP = P(:,T==t2);
        elseif isempty(t2)
            pP = P(:,T==t1);
        elseif d1 > d2
            pP = P(:,T==t2);
        else
            pP = P(:,T==t1);
        end
        [call.Peak.Power, argmax] = max(pP);
        call.Peak.Freq  = F(argmax);
            
        % start
        t1 = min(T(T>=call.StartTime));
        t2 = max(T(T<=call.StartTime));
        d1 = t1-call.StartTime;
        d2 = call.StartTime-t2;
        if isempty(t1)
            startT = t2;
        elseif isempty(t2)
            startT = t1;
        elseif d1 > d2
            startT = t2;
        else
            startT = t1;
        end
        [call.StartPower, argmax] = max(P(:,T==startT));
        call.Start.Freq = F(argmax);
            
        % end
        t1 = min(T(T>=call.EndTime));
        t2 = max(T(T<=call.EndTime));
        d1 = t1-call.EndTime;
        d2 = call.EndTime-t2;
        if isempty(t1)
            endT = t2;
        elseif isempty(t2)
            endT = t1;
        elseif d1 > d2
            endT = t2;
        else
            endT = t1;
        end
        [call.End.Power, argmax] = max(P(:,T==endT));
        call.End.Freq   = F(argmax);


        % spectrum
        call.SpectralData = sumAdminCompute(dataset(callStartPoint:callEndPoint),Fs);

end

