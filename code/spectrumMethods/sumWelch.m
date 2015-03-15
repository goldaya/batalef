function [ spec ] = sumWelch( TS, Fs, params )
%SUMWELCH Summary of this function goes here
%   Detailed explanation goes here

    spec.P = 10*log10(pwelch(TS));
    spec.F = Fs/2*linspace(0,1,length(spec.P));
    
end

