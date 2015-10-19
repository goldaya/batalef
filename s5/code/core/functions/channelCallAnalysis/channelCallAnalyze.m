function call = channelCallAnalyze( call, AnalysisWindow, dataset,envDataset, detectionPeakWindow, startThreshold, endThreshold, gapTolerance, forcedBoundries, computeSpectral, computeRidge )
%CHANNELCALLANALYZE Analyze channel call - find start, peak, end of call,
%ridge, spectral data.

    Fs = call.Fs;
    
    % keep parameters
    call.AnalysisParameters.startThreshold = startThreshold;
    call.AnalysisParameters.endThreshold = endThreshold;
    call.AnalysisParameters.gapTolerance = gapTolerance;
    call.AnalysisParameters.window = AnalysisWindow;
    call.AnalysisParameters.d2pWindow = detectionPeakWindow;
    call.AnalysisParameters.TS = dataset;
    call.AnalysisParameters.envelope = envDataset;
    call.AnalysisParameters.Fs = Fs;   
    
        
    window = call.Detection.Time+[-0.5,0.5].*AnalysisWindow;
    if isempty(forcedBoundries)
    %%% find peak %%%
        D2P = round((call.Detection.Time - window(1)+[-1,1].*(detectionPeakWindow/2)).*Fs);
        if D2P(1) < 1
            D2P(1) = 1;
        end
        if D2P(2) > length(envDataset)
            D2P(2) = length(envDataset);
        end
        [peakValue, peakPoint] = max( envDataset(D2P(1):D2P(2)) );
        peakPoint = peakPoint+D2P(1);
        call.Peak.Time  = peakPoint/Fs + window(1);
        call.Peak.Value = peakValue;

    %%% find start and end of call %%%
        maxGapInPoints = round(gapTolerance*Fs);
        startValue = peakValue * 10^(startThreshold/20);
        startPoint = peakPoint;
        gap = 0;
        for a=-peakPoint:-1
            i = -a;
            % if value is lower than threshold, take gap
            if envDataset(i)<startValue
                gap = gap + 1;
            else
                startPoint = i;
                gap = 0;
            end
            if gap > maxGapInPoints
                break;
            end
        end

        call.Start.Time  = startPoint/Fs + window(1);


        % find end point 
        endValue = peakValue * 10^(endThreshold/20);
        endPoint = peakPoint;
        gap = 0;
        for i=peakPoint:length(envDataset)
            % if value is lower than threshold, take gap
            if envDataset(i)<endValue
                gap = gap + 1;
            else
                endPoint = i;
                gap = 0;
            end
            if gap > maxGapInPoints
                break;
            end
        end

        call.End.Time  = endPoint/Fs + window(1);

    else
        call.Start.Time = forcedBoundries(1);
        call.End.Time = forcedBoundries(2);
        startPoint = max([floor((forcedBoundries(1) - window(1))*Fs),1]);
        endPoint = max([floor((forcedBoundries(2) - window(1))*Fs),1]);
        [peakValue, peakPoint] = max(envDataset(startPoint:endPoint));
        call.Peak.Time  = (peakPoint+startPoint)/Fs + window(1);
        call.Peak.Value = peakValue;        
        
    end
    
    call.Start.Value = envDataset(startPoint);
    call.End.Value = envDataset(endPoint);    
    
    
%%% spectral data %%%
    if computeSpectral
        call = channelCallComputeSpectralData(call,dataset,window(1));
    else
        % clear spectral data
    end
    
%%% ridge %%%
    if computeRidge
        call = channelCallComputeRidge(call, dataset, Fs);
    else
        call.Ridge = [];
    end
      
    
end

