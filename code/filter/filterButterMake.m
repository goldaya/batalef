function [ filterObject ] = filterButterMake( Fs, type, order, f1, f2 )
%FILTERBUTTERMAKE Make a butterworth filter out of parameters and Fs

    global c;
    
    filterObject = [];
    switch type
        case c.lowPass
            d = fdesign.lowpass('N,F3dB', order, f1, Fs);
        case c.highPass
            d = fdesign.highpass('N,F3dB', order, f1, Fs);
        case c.bandPass
            d = fdesign.bandpass('N,F3dB1,F3dB2',order,f1, f2, Fs);
        case c.bandStop
            d = fdesign.bandstop('N,F3dB1,F3dB2',order,f1, f2, Fs);
        otherwise
            return;
    end
    filterObject = design(d, 'butter');
end

