function [ ridge ] = rdgmYossi( dataset, Fs, params, extParams, varargin  )
%RDGMYOSSI Basic ridge function, starting from the peak outwards

    Finterval = params.Finterval;
    
    [~,F,T,P] = spectrogram(dataset,params.specWindow,params.specOverlap,params.specNfft,Fs);
    

    dF = round( Finterval/(F(2)-F(1)) );
    nF = length(F);
    nT = length(T);
    
    peakSlice = find((T + extParams.startTime)<= extParams.peakTime,1,'last');
    ridge = zeros(nT,3);
    ridge(peakSlice,1) = T(peakSlice);
    [ridge(peakSlice,3),pArgmax] = max(P(:,peakSlice));
    ridge(peakSlice,2) = F(pArgmax);
    
    fArgmax = pArgmax;
    for a = -(peakSlice-1):(-1)
        i = -a;
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

    fArgmax = pArgmax;
    for i = (peakSlice+1):nT
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

