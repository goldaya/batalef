function [ filt ] = getCustomFilter( Fs2use )
%GETCUSTOMFILTER Design a filter and get its object
%   Returns '[]' when filter is not to be used

    applyFilter = customFilterSpringboard(Fs2use);
    if applyFilter
        filt = evalin('base', 'ifilt');
    else
        filt = [];
    end    
    
end

