function [ filteredDataset, filterApplied, filterObject ] = filterButter( dataset, Fs, params )
%FILTERBUTTER Build filter and use on dataset

    filterObject = filterButterMake(Fs,params.type,params.order,params.f1,params.f2);
    try
        filteredDataset = filter(filterObject,dataset);
        filterApplied = true;
    catch err
        disp(err.message);
        filterApplied = false;
    end

end

function [ filterObject ] = filterButterMake( Fs, type, order, f1, f2 )
%FILTERBUTTERMAKE Make a butterworth filter out of parameters and Fs

    switch type
        case 'lowpass'
            d = fdesign.lowpass('N,F3dB', order, f1, Fs);
        case 'highpass'
            d = fdesign.highpass('N,F3dB', order, f1, Fs);
        case 'bandpass'
            d = fdesign.bandpass('N,F3dB1,F3dB2',order,f1, f2, Fs);
        case 'bandstop'
            d = fdesign.bandstop('N,F3dB1,F3dB2',order,f1, f2, Fs);
        otherwise
            errid = 'batalef:filter:butter:wrongType';
            errstr = sprintf('Wrong butterwurth filter typr: %s',type);
            throwAsCaller(MException(errid,errstr));
    end
    filterObject = design(d, 'butter');
end


