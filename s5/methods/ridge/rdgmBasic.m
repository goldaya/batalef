function [ ridge ] = rdgmBasic( spec,TS,params,extParams )
%RDGMBASIC Basic ridge function

    if strcmp(params.useInternalSpectrogram,'Yes')
        [~,F,T,P] = spectrogram(TS.dataset,params.internalSpecWindow,params.internalSpecOverlap,params.internalSpecNfft,TS.Fs);
        T = T + TS.offset;
    elseif isempty(spec)
        errid  = 'batalef:ridge:noSpectrogram';
        errstr = 'There is no spectrogram input, while the "use internal spectrogram" indicator is false';
        throwAsCaller(MException(errid,errstr));
    else
        F = spec.F;
        T = spec.T;
        P = spec.P;
    end
    
    dF = round( params.fInterval/(F(2)-F(1)) );
    nF = length(F);
    
    alphaSlice = find(T <= extParams.callStartTime,1,'last');
    betaSlice  = find(T <= extParams.callEndTime,1,'last');
    N = betaSlice - alphaSlice + 1;
    if N < 1
        ridge = zeros(0,3);
        return;
    else
        ridge = zeros(N,3);
        T = T(alphaSlice:betaSlice);
        P = P(:,alphaSlice:betaSlice);
        % F is unchanged
    end
    
    
    switch params.startPoint
        case 'Start'
            startSlice = 1;
        case 'Peak'
            startSlice = find(T <= extParams.callPeakTime,1,'last');
        otherwise
            errid  = 'batalef:ridge:wrongStartPoint';
            errstr = sprintf('The requested start point is invalid: %s. Use "Start" or "Peak"',params.startPoint);
            throwAsCaller(MException(errid,errstr));            
    end
    
    
    ridge(startSlice,1) = T(startSlice);
    [ridge(startSlice,3),pArgmax] = max(P(:,startSlice));
    ridge(startSlice,2) = F(pArgmax);
    
    fArgmax = pArgmax;
    for a = -(startSlice-1):(-1)
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
    for i = (startSlice+1):N
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

