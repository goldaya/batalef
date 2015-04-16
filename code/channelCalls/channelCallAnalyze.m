function call = channelCallAnalyze( k,j,s,type,window, dataset,envDataset, startThreshold, endThreshold, gapTolerance, computeSpectral, computeRidge )
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
    
%%% find peak %%%
    [peakValue, peakPoint] = max(envDataset);
    call.PeakTime  = peakPoint/Fs + window(1);
    call.PeakValue = peakValue;
    
%%% find start and end of call %%%
    maxGapInPoints = round(gapTolerance*Fs);
    startValue = peakValue * 10^(startThreshold/10);
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
    call.StartValue = envDataset(startPoint);

    % find end point 
    endValue = peakValue * 10^(endThreshold/10);
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
    call.EndValue = envDataset(endPoint);    
    
%%% spectral data %%%
    if computeSpectral
        call.Spectrograma = somAdminCompute(dataset, Fs);
        call.Spectrograma.T = call.Spectrograma.T + window(1);

        call = channelCallComputeSpectralData(call,dataset,Fs);
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

