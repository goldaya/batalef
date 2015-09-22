function [ val ] = getParFromVarargin( par, A )
%GETPARFROMVARARGIN Find the value of the parameter 'par' in the cell array
%A (which will probably be varargin of some function). If no parameter was
%found, returns false

    if isempty(A)
        val = false;
        return;
    end
    
    n = length(A);
    
    for i = 1:n
        if ischar(A{i}) && strcmp(A{i}, par) && i <= n
            val = A{i+1};
            return;
        end
    end

    val = false;
    
end

