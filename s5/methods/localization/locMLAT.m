function [ X,dT ] = locMLAT(times,micArray,sonic,~,~)
%LOCMLAT Localization method: MLAT

      
    T = times - times(1);
    X = MLAT( micArray, T, sonic );

end

