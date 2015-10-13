function [ spec ] = sumWelch( TS, Fs, ~ )
%SUMWELCH Compute welch spectrum decomposition

    spec.P = 10*log10(pwelch(TS));
    spec.F = Fs/2*linspace(0,1,length(spec.P));
    
end

