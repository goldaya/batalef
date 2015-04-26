function [ params, object, cancel ] = filterButterDlg( Fs, D )
%FILTERBUTTERDLG Summary of this function goes here
%   Detailed explanation goes here

    global c;
    
    params = [];
    object = [];
    cancel = false;
    
    if ~exist('D','var') || isempty(D)
        D{1} = filterButterTranslateName(getParam('filter:butter:type'));
        D{2} = num2str(getParam('filter:butter:f1'));
        D{3} = num2str(getParam('filter:butter:f2'));
        D{4} = num2str(getParam('filter:butter:order'));
    end
    
    Q{1} = 'Type: (Lowpass, Highpass, Bandpass, Bandstop)';
    Q{2} = 'Freq1, KHz: (for low- and highpass, this is the change freq. for band, this is the first freq to use)';
    Q{3} = 'Freq2, KHz: (for band stop and pass only. second freq to use)';
    Q{4} = 'Order:';
    
    ready = false;
    title = 'Butterworth Filter';
    while ~ready 
        A = inputdlg(Q,title, [1,70],D);

        % exit on cancel
        if isempty(A)
            cancel = true;
            return;
        else
            cancel = false;
        end

        f1 = 1000*str2double(A{2});
        f2 = 1000*str2double(A{3});
        order = str2double(A{4});
        
        % proceed with creating filter / outputing parameters
        type = filterButterTranslateName(A{1});
        if isempty(type)
            title = 'Butterworth Filter - Wrong Type';
            D = A;
            continue;
        else
            ready = true;
        end
        
        % check f2 > f1 on band filters
        if (type==c.bandPass || type==c.bandStop) && (str2double(A{2}) >= str2double(A{3}))
            title = 'Butterworth Filter - f2 must be higher than f1';
            D = A;
            continue;
        end
             
        %
        params.type = type;
        params.f1 = f1;
        params.f2 = f2;
        params.order = order;
        if exist('Fs','var') && ~isempty(Fs)
            object = filterButterMake(Fs,type,order,f1,f2);
        end
    end
    
end

