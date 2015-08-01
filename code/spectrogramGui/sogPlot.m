function [  ] = sogPlot(  )
%SOGPLOT Summary of this function goes here
%   Detailed explanation goes here

    global control;
    handles = sogGetHandles();
    
    % do
    k = control.sog.k;
    if k == 0
        return;
    end
    Fs = fileData(k,'Fs');
    J = control.sog.J;
    if isempty(J)
        return;
    end
    
    tOffset = control.sog.span(1)/Fs;
    for i = 1:length(J)
        % get data
        wdata = double(channelData(k,J(i),'TimeSeries', control.sog.span));

        % compute spectrogram
        spec = somAdminCompute(wdata, Fs);
        spec.T = spec.T + tOffset;
        
        % put on axes
        axesName = strcat('axes',num2str(i));
        axobj = handles.(axesName);
        axes(axobj);
        imagesc(spec.T,spec.F,spec.P);
        set(axobj,'YDir','normal');
        title(axobj,strcat(['Channel ',num2str(J(i))]));
        set(axobj,'UserData',J(i));
        
        % add channel calls
        [times,~,indexes] = channelData(k,J(i),'Calls','Detections','Interval',control.sog.span./Fs);
        if ~isempty(times)
            N = length(times);
            Ylim = get(axobj,'Ylim');
            dY = (Ylim(2)-Ylim(1))/2;
            Y = zeros(N,1)+dY;
            hold(axobj,'on');
            I = strtrim(cellstr(num2str(transpose(indexes))));
            text(times,Y,I);
            hold(axobj,'off');
        end
    end 


end

