function [ ridge ] = rdgmBasic( dataset, Fs, params, extParams, varargin  )
%RDGMBASIC Summary of this function goes here
%   Detailed explanation goes here

    Finterval = params.Finterval;
    
    [~,F,T,P] = spectrogram(dataset,params.specWindow,params.specOverlap,params.specNfft,Fs);
    

    dF = round( Finterval/(F(2)-F(1)) );
    nF = length(F);
    
    ridge = zeros(length(T),3);
    ridge(1,1) = T(1);
    [ridge(1,3),fArgmax] = max(P(:,1));
    ridge(1,2) = F(fArgmax);
    
    for i = 2:length(T);
        I = round([-0.5, 0.5].*dF + fArgmax);
        if I(1) < 1
            I(1) = 1;
        end
        if I(2) > nF
            I(2) = nF;
        end
        
        searchP = P(I(1):I(2),i);
        if isempty(searchP)
            ridge = [];
            return;
        end
        
        ridge(i,1) = T(i);
        [ridge(i,3), rfArgmax] = max(searchP);
        fArgmax = rfArgmax + I(1) - 1;
        ridge(i,2) = F(fArgmax);
        
    end

end

