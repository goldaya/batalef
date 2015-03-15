function [  ] = mgRefreshAxes( )
%MGREFRESHAXES Refresh axes plots

    global control;
    handles = mgGetHandles();
    

    % get the channels to display
    J = appData('Channels','Displayed');
    N = length(J);
   
    
    if N>0
        % plot channels
        k = control.mg.k;
        for i=1:N
            axesName = strcat('axes',num2str(i));
            mgPlotChannel(k, J(i), axesName);
        end
    end
    
    % clear un-needed axes objects
    if N < control.mg.nAxes;
       for i = N+1:control.mg.nAxes
           axesName = strcat('axes',num2str(i));
           cla(handles.(axesName));
           title(handles.(axesName),'');
       end
    end

end

