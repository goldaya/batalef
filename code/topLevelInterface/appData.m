function [ out ] = appData( par, varargin )
%APPDATA Info whoch is not file-, channel- or call- specific

    global filesObject;
    global control;
    
    
    switch par
        case 'Bytes'
            w = whos('filesObject');
            out = w.bytes;
        case 'Axes'
            switch varargin{1}
                case 'Count'
                    out = control.mg.nAxes;
                case 'Height'
                    single = getParam('mainGUI:axesHeight');
                    if length(varargin)>1 && strcmp(varargin{2},'Total')
                        out = single * control.mg.nAxes;
                    else
                        out = single;
                    end
                    
            end
        case 'Files'
            switch varargin{1}
                case 'Count'
                    out = length(filesObject);
                case 'Index'
                    out = getFileIndex(varargin{2});
                case 'Displayed'
                    out = control.mg.k;
                    
                case 'Selected'
                    out = transpose(find(cell2mat({filesObject.selected})));
            end
            
        case 'Channels'
            switch varargin{1}
                case 'Filter'
                    out = control.mg.channelsFilter;
                case 'Filtered'
                    if control.mg.k == 0
                        out = [];
                        return;
                    end
                    n = fileData(control.mg.k, 'Channels','Count');
                    if ~isempty(control.mg.channelsFilter)
                        tmp = control.mg.channelsFilter <= n;
                        out = control.mg.channelsFilter(tmp);
                    else
                        out = 1:n;
                    end
                case 'Displayed'
                    i = mgGetSliderStep();
                    K = appData('Channels','Filtered');
                    if isempty(K)
                        out = [];
                    elseif length(K) < control.mg.nAxes
                        out = K;
                    else
                        out = K(i+1:i+control.mg.nAxes);
                    end
                    
            end
    end


end

