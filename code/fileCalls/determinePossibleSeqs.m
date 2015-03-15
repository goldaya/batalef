function [ output_args ] = determinePossibleSeqs( k,jb,sb )
%DETERMINEPOSSIBLESEQS Summary of this function goes here
%   Detailed explanation goes here

    timePoint2Use = 'Start';
    deviance = 1.05;
    [GM, I] = buildGrandMatrix(k,jb,sb,timePoint2Use,deviance);
end