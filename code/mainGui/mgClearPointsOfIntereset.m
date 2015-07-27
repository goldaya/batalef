function mgClearPointsOfIntereset()
%MGCLEARPOINTSOFINTERESET Summary of this function goes here
%   Detailed explanation goes here

    arrayfun(@(k) removeSingleFile(k),mgResolveFilesToWork());
    mgRefreshAxes();
    
end

function removeSingleFile(k)
    global filesObject;
    for j = 1:fileData(k,'Channels','Count')
        filesObject(k).channels(j).pois = [];
    end
end