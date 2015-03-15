function [ filterApplied ] = filterFile( k, filterObject )
%FILTERFILE Filter all channels in a file

    global filesObject;
    preFilterData = fileData(k, 'TimeSeries');
    Fs = fileData(k,'Fs');
    [postFilterData, filterApplied] = applyFilterToData( preFilterData, Fs, filterObject );
    filesObject(k).rawData.data = postFilterData;
    filesObject(k).rawData.status = 'Filtered';
    % (assuming the data structure is unchanged)

end

