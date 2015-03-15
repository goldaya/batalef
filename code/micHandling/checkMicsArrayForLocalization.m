function [ rc, L ] = checkMicsArrayForLocalization( P, U )
%CHECKMICSARRAYFORLOCALIZATION INTERNAL Check if the array has enough
%usable mics in it


    rc = 3;
    L = [];
    
    N = getParam('mics:minimalN');
    if N > sum(U)
        rc = 1;
        return;
        %ans = questdlg('The minimal number of usable mics is lower than requested. The "Flight Path & Beam" gui will fail to launch (+ will be closed if now is open). To change the criteria goto "Mics Admin", menu item "Parameters->Set Array Parameters For Localization". Are you sure you want to continue?','Yes','No');
    end
    
    % get full array depth
    dP = max(P) - min(P);
    rdP = dP .* [getParam('mics:depth:X'),getParam('mics:depth:Y'),getParam('mics:depth:Z')];
    
    
    %get usable indexes
    I = 1:length(U);
    I = I(U);
    nI = length(I);
    
    % logicals of all combinations
    A = dec2bin(0:2^nI-1);      % produces strings
    B = A(2^N:size(A,1),:);     % take out the first N^2-1 since they always have less than N ones
    K = logical(double(B)-48);  % translate string to ascii vector, normalize, make boolean
    clear A B;
    
    idx = 1;
    L = cell(size(K,1),1);
    for i = 1:size(K,1)
        B = K(i,:); % boolean vector
        if sum(B) < N
            L(idx,:) = [];
            continue;
        else
            % check depth
            A = P(I(B),:);
            dA = max(A) - min(A);
            if min(dA-rdP) < 0
                L(idx,:) = [];
                continue;
            else
                L{idx,1} = I(B);
                tmp = zeros(length(I),1);
                tmp(I(B)) = 1;
                L{idx,2} = logical(tmp);
                idx = idx + 1;
            end
        end
    end
    
    % return code - error when no usable subarrays
    if isempty(L)
        rc = 2;
    else
        rc = 0;
    end
    
end