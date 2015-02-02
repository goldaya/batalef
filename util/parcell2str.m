function [ out ] = parcell2str( in )
%PARCELL2STR convert method par cell array into eval-able string

    out = '{';
    for i = 1:length(in)
        parName = in{i}{1};
        parText = in{i}{2};
        parDval = in{i}{3};
        if i~=1
            out = strcat(out, ',');
        end
        out = strcat(out,'{''',parName,''',''',parText,''',''',parDval,'''}');
    end
    out = strcat(out, '}');

end

