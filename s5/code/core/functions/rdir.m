function [ A ] = rdir( directory, arg )
%RDIR recursive dir
%   see also: dir ls 

    A = dir(strcat(directory,filesep(),arg));
    for i = 1:length(A)
        A(i).path = strcat(directory,filesep());
        A(i).fullpath = strcat(A(i).path,A(i).name);
    end
    if isempty(A)
        A = [];
    end
    
    D = dir(directory);
    for i = 1:length(D)
        if strcmp(D(i).name,'.') || strcmp(D(i).name,'..')
        elseif D(i).isdir
            R = rdir(strcat(directory,filesep(),D(i).name),arg);
            A = [A;R]; %#ok<AGROW>
        end
    end

end

