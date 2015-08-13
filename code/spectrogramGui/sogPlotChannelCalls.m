function [  ] = sogPlotChannelCalls(ax,k,j)
%SOGPLOTCHANNELCALLS add channel clls data to spectrograms

    global control;
    if ishandle(ax)
        axobj = ax;
        axName = get(ax,'tag');
    elseif ischar(ax)
        axName = ax;
        [~,axobj] = sogGetHandles(axName);
    else
        disp('missing axes definition for channel calls')
        return;
    end

    % clear older markers
    if isfield(control.sog,axName)
        if isfield(control.sog.(axName), 'ccTexts')
            ccTexts = control.sog.(axName).ccTexts;
            for i = 1:length(ccTexts)
                if ishandle(ccTexts(i))
                    delete(ccTexts(i));
                end
            end
            control.sog.(axName).ccTexts = [];
        end
    end

    % put new markers
    Fs = fileData(k,'Fs');
    [times,~,indexes] = channelData(k,j,'Calls','Detections','Interval',control.sog.span./Fs);
        if ~isempty(times)
            N = length(times);
            Ylim = get(axobj,'Ylim');
            dY = (Ylim(2)-Ylim(1))/2;
            Y = zeros(N,1)+dY;
            hold(axobj,'on');
            I = strtrim(cellstr(num2str(transpose(indexes))));
            control.sog.(axName).ccTexts = text(times,Y,I);
            hold(axobj,'off');
            set(axobj,'Tag',axName);
        end

end

