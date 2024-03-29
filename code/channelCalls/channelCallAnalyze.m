function call = channelCallAnalyze( k,j,s,type,window, dataset,envDataset, detectionPeakWindow, startThreshold, endThreshold, gapTolerance, forcedBoundries, computeSpectral, computeRidge )
%CHANNELCALLANALYZE Summary of this function goes here
%   Detailed explanation goes here

    % init call object
    call = channelCall(k,j,s,type,false);
    Fs = call.Fs;
        
    if isempty(dataset)
        dataset = channelData(k, j, 'TS', call.inPoints(call,window));
    end
    
    % get envelope
    if isempty(envDataset)
        envDataset = envmAdminCompute(dataset,Fs);
    end
    
    
    if isempty(forcedBoundries)
    %%% find peak %%%
        D2P = call.inPoints(call,call.DetectionTime - window(1)+[-1,1].*(detectionPeakWindow/2));
        if D2P(1) < 1
            D2P(1) = 1;
        end
        if D2P(2) > length(envDataset)
            D2P(2) = length(envDataset);
        end
        [peakValue, peakPoint] = max( envDataset(D2P(1):D2P(2)) );
        peakPoint = peakPoint+D2P(1)-1;
        call.PeakTime  = peakPoint/Fs + window(1);
        call.PeakValue = peakValue;

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

        call.StartTime  = startPoint/Fs + window(1);


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

        call.EndTime  = endPoint/Fs + window(1);

    else
        call.StartTime = forcedBoundries(1);
        call.EndTime = forcedBoundries(2);
        startPoint = max([floor((forcedBoundries(1) - window(1))*Fs),1]);
        endPoint = max([floor((forcedBoundries(2) - window(1))*Fs),1]);
        [peakValue, peakPoint] = max(envDataset(startPoint:endPoint));
        call.PeakTime  = (peakPoint+startPoint)/Fs + window(1);
        call.PeakValue = peakValue;        
        
    end
    
    call.StartValue = envDataset(startPoint);
    call.EndValue = envDataset(endPoint);    
    
%%% spectral data %%%
    if computeSpectral
        call.Spectrograma = somAdminCompute(dataset, Fs);
        call.Spectrograma.T = call.Spectrograma.T + window(1);

        call = channelCallComputeSpectralData(call,dataset,Fs,startPoint,endPoint);
    else
        % clear spectral data
    end
    
%%% ridge %%%
    if computeRidge
        call = channelCallComputeRidge(call, dataset(startPoint:endPoint), Fs);
    else
        call.Ridge = [];
    end
    
end

