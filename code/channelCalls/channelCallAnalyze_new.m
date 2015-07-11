function call = channelCallAnalyze_new( k,j,s,type,window, dataset,envDataset, startThreshold, endThreshold, gapTolerance, forcedBoundries, computeSpectral, computeRidge )
%J Summary of this function goes here
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
        [peakValue, peakPoint] = max(envDataset);
        call.PeakTime  = peakPoint/Fs + window(1);
        call.PeakValue = peakValue;

    %%% find start and end of call %%%
        maxGapInPoints = round(gapTolerance*Fs);
        
        % start
        startValue = peakValue * 10^(startThreshold/20);
        I = 1:peakPoint;
        S = envDataset(I); % start dataset
        I = I(S>=startValue); % all points above the threshold
        if length(I) > 1
            I1 = I(1:length(I)-1);
            I2 = I(2:length(I));
            D = I2 - I1;
            if max(D) <= maxGapInPoints
                startPoint = I(1);
            else
                D(D<=maxGapInPoints) = 0;
                i = find(D,1,'last'); % get the last gap which is longer than allowed
                startPoint = I2(i);
            end
        else
            startPoint = peakPoint;
        end
        clear S I1 I2 I;
        
        % end
        endValue = peakValue * 10^(endThreshold/20);
        I = peakPoint:length(envDataset);
        E = envDataset(I); % end dataset
        I = I(E>=endValue); % all points above the threshold
        if length(I) > 1
            I1 = I(1:length(I)-1);
            I2 = I(2:length(I));
            D = I2 - I1;
            if max(D) <= maxGapInPoints
                endPoint = I(length(I));
            else
                D(D<=maxGapInPoints) = 0;
                i = find(D,1,'first'); % get the last gap which is longer than allowed
                endPoint = I1(i);
            end
        else
            endPoint = peakPoint;
        end
        
        
        call.StartTime  = startPoint/Fs + window(1);
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

