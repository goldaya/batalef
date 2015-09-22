function [ spec ] = somSTFT( dataset, Fs, params )
%SOMSTFT compute spectrogram using Matlab's built in spectrogram function -
%Short Time Fourier Transform.

    [~,F,T,P] = spectrogram(dataset,params.window,params.overlap,params.nfft,Fs);
    spec.T = T;
    spec.F = F;
    spec.P = 10*log10(abs(P));
    
end

