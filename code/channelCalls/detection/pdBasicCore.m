function peaks = pdBasicCore( dataset, Fs, threshold, minDistance, npeaks )
%PDBASICCORE Basic peaks detection
%   rdata = raw data (structure: data, Fs)
%   threshold = minimum value for peaks
%   minDistance = minimal distance between peaks (msec)
%   npeaks = maximal number of peaks. 0 for infty

    % translate minDistance to points
    technicalMinDistance = minDistance.*Fs/1000;
    
    [V,L] = findpeaks(dataset,...
        'MINPEAKHEIGHT', threshold, ...
        'MINPEAKDISTANCE',technicalMinDistance,...
        'SORTSTR', 'descend');
    
    if npeaks > 0
        n = min(npeaks, length(L));
        V = V(1:n);
        L = L(1:n);
    end
    
    % make sure you output as column vectors
    if size(V, 1) == 1
        V = transpose(V);
    end
    if size(L, 1) == 1
        L = transpose(L);
    end
    
    % sort ascending by point index
    Q = sortrows([L V]);
    peaks.points = Q(:,1);
    peaks.times  = Q(:,1)./Fs;
    peaks.values = Q(:,2);

end

