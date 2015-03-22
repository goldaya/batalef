function [ Uout ] = enforceCommonDefaults( Uin )
%ENFORCECOMMONDEFAULTS Make sure the parameters file has the right
%parameters

    % read common default file
    fid = fopen('./common/default.bpf');
    C = textscan(fid, '%s %s %f'); % name, type, value(float)
    fclose(fid);
    C{3} = num2cell(C{3});
    
    % for each param in C, put the value for it from the input User data.
    % if absent use the default from C
    Uout{1} = cell(0,1);
    Uout{2} = cell(0,1);
    Uout{3} = cell(0,1);
    for i = 1:size(C{1},1)
        j = find(strcmp(C{1}{i},Uin{1}));
        if isempty(j)
            Uout{1}{i,1} = C{1}{i};
            Uout{2}{i,1} = C{2}{i};
            Uout{3}{i,1} = C{3}{i};
        else
            Uout{1}{i,1} = Uin{1}{j};
            Uout{2}{i,1} = Uin{2}{j};
            Uout{3}{i,1} = Uin{3}{j};            
        end
    end


end

