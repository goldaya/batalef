function [ filterObject ] = filterBuilderGetFilter(  )
%FILTERBUILDERGETFILTER Get a filter object from filterbuilder

    filterbuilder_i;
    uiwait(msgbox('Push "OK" only after you have finished with the filter builder','modal'));
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

