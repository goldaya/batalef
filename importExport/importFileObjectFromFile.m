function [  ] = importFileObjectFromFile(  )
%IMPORTFILEOBJECTFROMFILE Summary of this function goes here
%   Detailed explanation goes here

    [filename, path] = uigetfile({'*.mat','Matlab File (*.mat)'});
    if filename==0
        return;
    end
    
    fobj = importdata(strcat(path,filename));
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

