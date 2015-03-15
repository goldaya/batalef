function [ out ] = filterButterDlg( Fs )
%FILTERBUTTERDLG Summary of this function goes here
%   Detailed explanation goes here

    global c;
    
    out = [];
    
    Q{1} = 'Type: (Lowpass, Highpass, Bandpass, Bandstop)';
    switch getParam('filter:butter:type')
        case c.lowPass
            D{1} = 'Lowpass';
        case c.highPass
            D{1} = 'Highpass';
        case c.bandPass
            D{1} = 'Bandpass';
        case c.bandStop
            D{1} = 'Bandstop';
    end
    
    Q{2} = 'Freq1, KHz: (for low- and highpass, this is the change freq. for band, this is the first freq to use)';
    D{2} = num2str(getParam('filter:butter:f1'));

    Q{3} = 'Freq2, KHz: (for band stop and pass only. second freq to use)';
    D{3} = num2str(getParam('filter:butter:f2'));
    
    Q{4} = 'Order:';
    D{4} = num2str(getParam('filter:butter:order'));
    
    ready = false;
    title = 'Butterworth Filter';
    while ~ready 
        A = inputdlg(Q,title, [1,70],D);

        % exit on cancel
        if isempty(A)
            return;
        end

        f1 = 1000*str2double(A{2});
        f2 = 1000*str2double(A{3});
        order = str2double(A{4});
        
        % proceed with creating filter / outputing parameters
        switch A{1}
            case 'Lowpass'
                type = c.lowPass;
                ready = true;
            case 'Highpass'
                type = c.highPass;
                ready = true;
            case 'Bandpass'
                type = c.bandPass;
                ready = true;
            case 'Bandstop'
                type = c.bandStop;
                ready = true;
            otherwise
                title = 'Butterworth Filter - Wrong Type';
                D = A;
                continue;
        end
        
        % check f2 > f1 on band filters
        if (type==c.bandPass || type==c.bandStop) && (str2double(A{2}) >= str2double(A{3}))
            title = 'Butterworth Filter - f2 must be higher than f1';
            D = A;
            continue;
        end
        
        % keep values into parameters array
        filterButterKeepValues(type,order,f1,f2);
        
        %
        if exist('Fs','var') && ~isempty(Fs)
            out = filterButterMake(Fs,type,order,f1,f2);
        else
            out.type = type;
            out.f1 = f1;
            out.f2 = f2;
            out.order = order;
        end
    end
    
end

