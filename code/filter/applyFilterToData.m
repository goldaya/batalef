function [dataOut, filterApplied] = applyFilterToData( dataIn, Fs, filter2use  )
%APPLYFILTER Apply a filter to dataset
    
    global c;
    
    if isempty(filter2use)
        dataOut = dataIn;
    elseif isstruct(filter2use) && isfield(filter2use,'method')
        switch filter2use.method
            case c.function
                filterFunc = evalin('base',filter2use.function);
                dataOut = filterFunc(dataIn, Fs);
                filterApplied = true;
            case c.butter
                filterObj = filterButterMake(Fs,filter2use.type,...
                    filter2use.order, filter2use.f1, filter2use.f2);
                dataOut = filter( filterObj , dataIn );
                filterApplied = true;
        end
    else
        % try to filter
        try
            dataOut = filter( filter2use,dataIn );
            filterApplied = true;
        catch err
            dataOut = dataIn;
            filterApplied = false;
        end
    end
        
end

