function int = str2int_compact( str )
%STR2INT_COMPACT convert a string to a compact vector of integers
% see also int2str_compact

    int = sort(unique(round(str2num(str)))); %#ok<ST2NM>
    
end

