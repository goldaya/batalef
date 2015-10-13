function [ spec ] = sumFFT( TS, Fs, ~ )
%SUMFFT Compute FFT spectrum decomposition

    n = length(TS);
    S = fft(TS, n);
    P = S.*conj(S)/n;
    spec.P = 10*log10(P(1:round(n/2)));
    N = int32(length(spec.P)/2);
    spec.F = Fs/2*linspace(0,1,N);
    
end

