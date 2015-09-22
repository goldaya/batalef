function [ str ] = int2str_compact( vector )
%INT2STR_COMPACT Gets a vector of integers and returns a compact string
%representation

    if isempty(vector)
        str = '';
        return;
    end
    err = MException('int2str:notIntegers','The input vector has non integer values');
    if ~isempty(find(mod(vector,1),1))
        throw(err)
    end
    if ~isnumeric(vector)
        throw(err)
    end
    
    V = unique(sort(vector));
    V1 = V(1:length(V)-1);
    V2 = V(2:length(V));
    D = find(V2 - V1 - 1);
    D1 = [1,1+D];
    D2 = [D,length(V)];
    i = 1;
    if V(D1(i)) == V(D2(i))
        str = num2str(V(D1(i)));
    else
        str = strcat(num2str(V(D1(i))),':',num2str(V(D2(i))));
    end
    for i = 2:length(D1)
        if V(D1(i)) == V(D2(i))
            str = strcat(str,',',num2str(V(D1(i))));
        else
            str = strcat(str,',',num2str(V(D1(i))),':',num2str(V(D2(i))));
        end
    end

end

