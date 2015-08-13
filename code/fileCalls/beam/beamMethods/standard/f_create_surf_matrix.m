    function [matrix] = f_create_surf_matrix(signal,geo_mic_pos,pad_factor,sph_mic_pos,useSph)

    if ~useSph
        %Create rect as max geo size
        geo_mic_pos = round(geo_mic_pos.*100);
        ming = min(min(geo_mic_pos));
        geo_mic_pos = geo_mic_pos-ming;

        matrix=NaN(max(geo_mic_pos(:,3))+1,max(geo_mic_pos(:,1))+1);
        %Put values
        for i=1:size(signal,1)
            x=signal(i,:);
            matrix(geo_mic_pos(i,3)+1,geo_mic_pos(i,1)+1)=(norm(x)^2)/length(x);
        end
    
    else
    
        % make a 50 x 50 matrix
        maxAz = max(sph_mic_pos(:,1));
        maxEl = max(sph_mic_pos(:,2));
        AZ = round(sph_mic_pos(:,1).*(50/maxAz));
        EL = round(sph_mic_pos(:,2).*(50/maxEl));

        matrix=NaN(max(EL)+1,max(AZ)+1);
        %Put values
        for i=1:size(signal,1)
            x=signal(i,:);
            matrix(EL+1,AZ+1)=(norm(x)^2)/length(x);
        end
    
    end

    
    %Bitonic filter
    matrix_n2z=matrix; matrix_n2z(isnan(matrix_n2z))=0;
    [~,get_col]=max(sum(abs(matrix_n2z),1));
    [~,get_row]=max(sum(abs(matrix_n2z),2));
    clear matrix_n2z;
    row=f_bitonic_filter(matrix(get_row,:));
    row_smth=smooth(row(~isnan(row)),5);
    row(~isnan(row))=row_smth;
    matrix(get_row,:)=row;
    col=f_bitonic_filter(matrix(:,get_col)')';
    col_smth=smooth(col(~isnan(col)),5);
    col(~isnan(col))=col_smth;
    matrix(:,get_col)=col;

    %Boundry circle conditions
    s=max(size(matrix))*pad_factor;
    pad_matrix=padarray(matrix,[ceil((s-size(matrix,1))/2) 0],NaN,'both');
    pad_matrix=padarray(pad_matrix,[0 ceil((s-size(matrix,2))/2)],NaN,'both');
    r=floor(min(size(pad_matrix))/2);
    
    for n=1:size(pad_matrix,1)
        for m=1:size(pad_matrix,2)
            if((n-r)^2+(m-r)^2>r^2)
                pad_matrix(n,m)=0;
            end
        end
    end
    

    matrix=inpaint_nans(pad_matrix,1);
    
