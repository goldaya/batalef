function [ has, idx ] = vHas( V,str )
%VHAS check varargin has a parameter name. Returns "has" and index

    idx = find(strcmp(V,str),1);
    if isempty(idx)
        has = false;
    else
        has = true;
    end

end

