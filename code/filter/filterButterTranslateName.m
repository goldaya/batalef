function [ out ] = filterButterTranslateName( in )
%FILTERBUTTERTRANSLATENAME Translate between the id and name of butter
%filter type
    global c;
    
    if ischar(in)
        switch in
            case 'Lowpass'
                out = c.lowPass;
            case 'Highpass'
                out = c.highPass;
            case 'Bandpass'
                out = c.bandPass;
            case 'Bandstop'
                out = c.bandStop;
        end
    elseif isnumeric(in)
        switch in
            case c.lowPass
                out = 'Lowpass';
            case c.highPass
                out = 'Highpass';
            case c.bandPass
                out = 'Bandpass';
            case c.bandStop
                out = 'Bandstop';
        end        
    end

end

