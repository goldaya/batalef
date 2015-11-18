function [out] = f_bitonic_filter(in)    
out=in;    
[~,max_pos]=max(in);
max_val=in(1);
for i=2:max_pos-1
    if (~isnan(in(i)) )
        if (in(i)<max_val)
            out(i)=NaN;
        else
            max_val=in(i);
        end
    end
end

max_val=in(end);
for i=size(in,2):-1:max_pos+1
    if (~isnan(in(i)) )
        if (in(i)<max_val)
            out(i)=NaN;
        else
            max_val=in(i);
        end
    end
end
