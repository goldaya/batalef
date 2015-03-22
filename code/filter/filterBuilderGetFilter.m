function [ filterObject, cancel ] = filterBuilderGetFilter(  )
%FILTERBUILDERGETFILTER Get a filter object from filterbuilder

    filterbuilder_i;
    answer = questdlg('Apply filter ONLY after it is defined and saved!','Custom filter','Apply','Cancel','Apply');
    %uiwait(msgbox('Push "OK" only after you have finished with the filter builder','modal'));
    if strcmp(answer,'Apply')
        cancel = true;
        filterObject = [];
        return;
    else
        cancel = false;
    end
    try
        filterObject = evalin('base', 'ifilt');
        evalin('base','clear ifilt');
    catch err
        if strcmp(err.identifier, 'MATLAB:UndefinedFunction')
            filterObject = [];
        else
            throw(err)
        end
    end

end

