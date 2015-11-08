function [ X,t ] = locMLAT(times,micArray,sonic,~,~)
%LOCMLAT Localization method: MLAT

      
    T = times - times(1);
    X = MLAT( micArray, T, sonic );
    t = times(1);

end

