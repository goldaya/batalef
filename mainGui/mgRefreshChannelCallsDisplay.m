function [  ] = mgRefreshChannelCallsDisplay(  )
%MGREFRESHCHANNELCALLSDISPLAY Refresh the channel calls display on the axes

    J = appData('Channels','Displayed');
    if isempty(J)
        return;
    end
    
    k = appData('Files','Displayed');

    for i = 1:length(J)
        axesName = strcat('axes',num2str(i));
        mgPlotChannelCalls(k,J(i),axesName);
    end


end

