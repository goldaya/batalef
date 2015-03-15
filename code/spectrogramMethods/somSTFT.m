function [ spec ] = somSTFT( dataset, Fs, params )
%SOMSTFT 

    [~,F,T,P] = spectrogram(dataset,params.window,params.overlap,params.nfft,Fs);
    spec.T = T;
    spec.F = F;
    spec.P = 10*log10(abs(P));
    
end

