function [  ] = sogPlot(  )
%SOGPLOT Summary of this function goes here
%   Detailed explanation goes here

    global control;
    handles = sogGetHandles();
    
    % do
    k = appData('Files','Displayed');
    if k == 0
        return;
    end
    Fs = fileData(k,'Fs');
    J = appData('Channels','Displayed');
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
        
        surf(axobj,spec.T,spec.F,spec.P,'edgecolor','none');
        view(axobj, [0,90]);
        axis(axobj, 'tight'); 
        title(axobj,strcat(['Channel ',num2str(J(i))]));
        
        % add channel calls
        [times,~,indexes] = channelData(k,J(i),'Calls','Detections','Interval',control.sog.span./Fs);
        if ~isempty(times)
            N = length(times);
            Ylim = get(axobj,'Ylim');
            dY = (Ylim(2)-Ylim(1))/2;
            Y = zeros(N,1)+dY;
            Zlim = get(axobj,'Zlim');
            Z = zeros(N,1)+Zlim(2);
            axes(axobj);
            hold(axobj,'on');
            plot3(axobj,times,Y,Z,'*','Color','black');
            I = strtrim(cellstr(num2str(transpose(indexes))));
            text(times,Y+(dY/3),Z,I);
            hold(axobj,'off');
        end
    end 


end

