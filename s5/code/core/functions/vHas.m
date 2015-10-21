function [ has, idx, next ] = vHas( V,str )
%VHAS check varargin has a parameter name. Returns "has" and index

    idx = find(strcmp(V,str),1);
    if isempty(idx)
        has = false;
        next = [];
    else
        has = true;
        try
            next = V{idx+1};
        catch 
            next = [];
        end
    end

end

