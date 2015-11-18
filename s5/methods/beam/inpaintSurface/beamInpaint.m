function [ d,w,i,surface ] = beamInpaint( batx,mics,powers,~,surfParams )
%BEAMINPAINT basic beam surface fitting

    d = [];
    w = [];
    i = [];

    nmics = size(mics,1);
    rzero = surfParams.zero - batx;
    rmics = mics - ones(nmics,1)*batx;
    zsph = mcart2sph(rzero,'degree');
    msph = mcart2sph(rmics,'degree');
    micDirections = msph - ones(nmics,1)*zsph;    
    
    azCoors = linspace(surfParams.azRange(1),surfParams.azRange(2),diff(surfParams.azRange)/surfParams.res);
    elCoors = linspace(surfParams.elRange(1),surfParams.elRange(2),diff(surfParams.elRange)/surfParams.res);
    
    % create initial matrix and put known values in it
    M = NaN(length(elCoors),length(azCoors));
    for i = 1:length(powers)
        % get the most appropiate cell
        A = abs(azCoors - micDirections(i,1));
        [~,iAZ] = min(A);
        A = abs(azCoors - micDirections(i,2));
        [~,iEL] = min(A);
        M(iEL,iAZ) = powers(i);
    end

    % Bitonic filter
    matrix_n2z=M; 
    matrix_n2z(isnan(matrix_n2z))=0;
    [~,get_col]=max(sum(abs(matrix_n2z),1));
    [~,get_row]=max(sum(abs(matrix_n2z),2));
    clear matrix_n2z;
    row=f_bitonic_filter(M(get_row,:));
    row_smth=smooth(row(~isnan(row)),5);
    row(~isnan(row))=row_smth;
    M(get_row,:)=row;
    col=f_bitonic_filter(M(:,get_col)')';
    col_smth=smooth(col(~isnan(col)),5);
    col(~isnan(col))=col_smth;
    M(:,get_col)=col;
    
    % boundry conditions
    S = size(M);
    M(:,1) = zeros(S(1),1);
    M(:,S(2)) = zeros(S(1),1);
    M(1,:) = zeros(1,S(2));
    M(S(1),:) = zeros(1,S(2));
        
    % interpolation
    surface = inpaint_nans(M,1);    

end