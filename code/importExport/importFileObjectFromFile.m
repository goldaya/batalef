function [  ] = importFileObjectFromFile( fullpath )
%IMPORTFILEOBJECTFROMFILE Summary of this function goes here
%   Detailed explanation goes here

    if ~exist('fullpath','var') || isempty(fullpath)
        [filename, path] = uigetfile({'*.mat','Matlab File (*.mat)'});
        if filename==0
            return;
        else
            fullpath = strcat(path,filename);
        end
    end
    
    fobj = importdata(fullpath);
    if isstruct(fobj)
        addFileObject( fobj );
    elseif iscell(fobj)
        for i=1:length(fobj)
            if isstruct(fobj{i})
                addFileObject( fobj{i} );
            end
        end
    end    
end

