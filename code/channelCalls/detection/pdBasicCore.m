function peaks = pdBasicCore( dataset, Fs, threshold, minDistance, npeaks )
%PDBASICCORE Basic peaks detection
%   rdata = raw data (structure: data, Fs)
%   threshold = minimum value for peaks
%   minDistance = minimal distance between peaks (msec)
%   npeaks = maximal number of peaks. 0 for infty

    % translate minDistance to points
    technicalMinDistance = minDistance.*Fs;
    
    [V,L] = findpeaks(dataset,...
        'MINPEAKHEIGHT', threshold, ...
        'MINPEAKDISTANCE',technicalMinDistance,...
        'SORTSTR', 'descend');
    
    % make sure you output as column vectors
    if size(V, 1) == 1
        V = transpose(V);
    end
    if size(L, 1) == 1
        L = transpose(L);
    end
    
    T = L./Fs;
    detections = [T,V];

end

