function [ fca ] = exportFileObject( K, withRawData )
%EXPORTFILEOBJECT Summary of this function goes here
%   Detailed explanation goes here

    global filesObject;
    if isempty(K) 
        return;
    end
    
    fca = cell(length(K),1);
    for i = 1:length(K)
        
        if ~validateFileIndex(K(i),true)
            continue;
        end
        
        fca{i} = filesObject(K);
        if withRawData
            if isempty(fca{i}.rawData.data)
                fca{i}.rawData.data = audioRead(fileData(K(i),'Fullpath'));
            end
        else
            fca{i}.rawData.data = [];
        end
        
    end
    
    V = inputdlg('Assign data to variable:');
    if ~isempty(V)
        var = V{1};
        assignin('base', var, fca);
        disp(' ');
        disp(strcat(['  ',var,' is now cell array with file objects']))
    end
    
end

