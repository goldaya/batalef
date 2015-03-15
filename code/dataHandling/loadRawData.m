function [  ] = loadRawData( K )
%LOADRAWDATA Delete existing raw data and load from file / keep empty
%according to settings

    if isempty(K)
        return;
    end
    
    for i = 1:length(K)
        refreshRawData(K(i), getParam('rawData:loadWithMatrix'));
    end
    
    mgRefreshFilesTable();
    
end

