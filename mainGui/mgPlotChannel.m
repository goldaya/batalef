function [  ] = mgPlotChannel( k, j, axesName )
%MGPLOTCHANNEL Put a channel on display on a specific axes object
    
    global control;
    global c;
    
    [~,axobj] = mgGetHandles(axesName);
    
    [TS,T] = channelData(k,j,'TS');
    %{
    if getParam('mainGUI:decimateDisplay')
       TS = resample( TS, control.mg.decimateDisplay.p, control.mg.decimateDisplay.q);
       rT = linspace(T(1),T(length(T)),length(TS));
       T = rT;
    end
    %}
    
    % plot
    X = get(axobj,'Xlim');
    Y = get(axobj,'Ylim');
    hold off;
    control.mg.tsPlots.(axesName) = plot(axobj,T,TS);
    
    % title
    title(axobj,strcat(['Channel ',num2str(j)]));
    
    % calls
    mgPlotChannelCalls(k,j,axesName);
    mgPlotPwpdLines(axesName);
    
    % zoom
    axis(axobj,'tight');
    zoom(axobj,'reset');
    if control.mg.axesMode == c.keep && control.mg.lockZoom
        set(axobj,'Xlim',X);
        set(axobj,'Ylim',Y);
    end
    
    %
    set(axobj,'Tag',axesName);

end

