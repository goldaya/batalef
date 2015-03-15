function [  ] = keepOnly( k, N )
%KEEPONLY resample and keep only N samples
%   Detailed explanation goes here
   
    n = fileData(k, 'nSamples');
    if n > N
        resample_i( k , N, n );
    end    

end