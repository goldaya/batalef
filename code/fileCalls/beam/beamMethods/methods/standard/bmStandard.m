function [ IM, direction, width, power ] = bmStandard( powers, micDirections, azCoors, elCoors, ~ )
%BMSTANDARD

    M = computeRawImage( azCoors, elCoors, micDirections(:,1), micDirections(:,2), powers );
    
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
    IM = inpaint_nans(M,1);
    
    % under dev
    direction = [];
    width = [];
    power = [];
    
end

