function [ raw, interpolated ] = bmStandard( powers, micDirections, azCoors, elCoors, params )
%BMSTANDARD

    % create initial matrix and put know values in it
    M = NaN(length(elCoors),length(azCoors));
    for i = 1:length(powers)
        % get the most appropiate cell
        A = abs(azCoors - micDirections(i,1));
        [~,iAZ] = min(A);
        A = abs(azCoors - micDirections(i,2));
        [~,iEL] = min(A);
        M(iEL,iAZ) = powers(i);
    end

    raw = M; % interface requires data before interpolation
    
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
    interpolated = inpaint_nans(M,1);
    
    %{
    % logarithmic scale
    interpolated = 10*log10(interpolated);
    raw = 10*log10(raw);
    %}
end

