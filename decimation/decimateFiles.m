function [  ] = decimateFiles( K )
%DECIMATEFILES Decimate selected files

    if isempty(K)
        return;
    end
    
    ret = decimation();
    if ret.p > 0 && ret.q > 0
        for i = 1:length(K)
            resample_i(K(i),ret.p, ret.q);
        end
    elseif ret.N > 0
        for i = 1:length(K)
            keepOnly(K(i),ret.N);
        end
    end

end

