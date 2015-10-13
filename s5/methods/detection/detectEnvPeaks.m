function detections = detectEnvPeaks( ~,envDataset,Fs,params )
%DETECTENVPEAKS Find peaks on an enveloped dataset using the built-in
%findpeaks function

    % translate minDistance to points
    technicalMinDistance = params.minimalDistance.*Fs;
    
    % threshold
    p = prctile(envDataset,params.percentile);
    if isempty(params.fixedThreshold) 
        threshold = p;
    elseif p > params.fixedThreshold 
        threshold = p;
    else
        threshold = params.fixedThreshold;
    end
    
    % A = amplitude, P = point
    w = warning('query','signal:findpeaks:largeMinPeakHeight');
    warning('off','signal:findpeaks:largeMinPeakHeight')
    [A,P] = findpeaks(envDataset,...
        'MINPEAKHEIGHT', threshold, ...
        'MINPEAKDISTANCE',technicalMinDistance,...
        'SORTSTR', 'descend');
    warning(w.state,'signal:findpeaks:largeMinPeakHeight')
    
    % make sure you output as column vectors
    if size(A, 1) == 1
        A = transpose(A);
    end
    if size(P, 1) == 1
        P = transpose(P);
    end
    
    % Translate into times and exit
    T = P./Fs;
    detections = [T,A];

end

