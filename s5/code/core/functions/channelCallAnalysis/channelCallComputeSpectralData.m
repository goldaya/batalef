function call = channelCallComputeSpectralData( call, dataset, offset )
%CHANNELCALLCOMPUTESPECTRALDATA compute channel call spectral data - call's
%start, peak & end fundomental frequency and power, spectrogram and
%spectrum

    global control;
    
        spec = control.app.Methods.callAnalysisSpectrogram.execute(dataset, call.Fs);
        spec.T = spec.T + offset;
        
        T = spec.T;
        F = spec.F;
        P = spec.P;
        
       
        % stats
        % find principle frequency at start, peak, end: get the closest
        % coordinate to start/peak/end, and then take max on the spectrogram
        % slice

        % peak
        t1 = min(T(T>=call.Peak.Time));
        t2 = max(T(T<=call.Peak.Time));
        d1 = t1-call.Peak.Time;
        d2 = call.Peak.Time-t2;
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
        t1 = min(T(T>=call.Start.Time));
        t2 = max(T(T<=call.Start.Time));
        d1 = t1-call.Start.Time;
        d2 = call.Start.Time-t2;
        if isempty(t1)
            startT = t2;
        elseif isempty(t2)
            startT = t1;
        elseif d1 > d2
            startT = t2;
        else
            startT = t1;
        end
        [call.Start.Power, argmax] = max(P(:,T==startT));
        call.Start.Freq = F(argmax);
            
        % end
        t1 = min(T(T>=call.End.Time));
        t2 = max(T(T<=call.End.Time));
        d1 = t1-call.End.Time;
        d2 = call.End.Time-t2;
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

        % keep spectrogram
        call.AnalysisParameters.spectrogram = spec;

        % spectrum
        call.AnalysisParameters.spectrum = control.app.Methods.callAnalysisSpectrum.execute(call.TS,call.Fs);

end

