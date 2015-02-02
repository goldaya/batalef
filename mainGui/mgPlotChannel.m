function [  ] = mgPlotChannel( k, j, axesName )
%MGPLOTCHANNEL Put a channel on display on a specific axes object
    
    global control;
    
    [~,axobj] = mgGetHandles(axesName);
    
    [TS,T] = channelData(k,j,'TS');
    if getParam('mainGUI:decimateDisplay')
       TS = resample( TS, control.mg.decimateDisplay.p, control.mg.decimateDisplay.q);
       rT = linspace(T(1),T(length(T)),length(TS));
       T = rT;
    end
    
    % plot
    X = get(axobj,'Xlim');
    Y = get(axobj,'Ylim');    
    control.mg.tsPlots.(axesName) = plot(axobj,T,TS);
    
    % title
    title(axobj,strcat(['Channel ',num2str(j)]));
    
    % calls
    mgPlotChannelCalls(k,j,axesName);
    mgPlotPwpdLines(axesName);
    
    % zoom
    if control.mg.lockZoom
        set(axobj,'Xlim',X);
        set(axobj,'Ylim',Y);
    else
        axis(axobj,'tight');
    end
    
    %
    set(axobj,'Tag',axesName);

end

