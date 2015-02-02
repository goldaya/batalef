function [  ] = sugPlot( a )
%SUGPLOT Plot spectrum


    handles = sugGetHandles();
    k = appData('Files','Displayed');
    Fs = fileData(k,'Fs');
    
    da = diff(a);  
    
    % for each displayed channel, compute and plot spectrum
    J = appData('Channels','Displayed');
    if isempty(J)
        return;
    end
    
    for i = 1:length(J)
        
        % compute spectrum
        D = double(channelData(k,J(i),'TimeSeries', a));
        spec = sumAdminCompute(D,Fs);%fft(D,n);
       
        % plot
        axesName = strcat('axes',num2str(i));
        plot(handles.(axesName), spec.F, spec.P);  
        axis(handles.(axesName), 'tight');
        xlabel(handles.(axesName), 'Frequency');
        ylabel(handles.(axesName), 'dB');
        set(handles.(axesName), 'YLim', [-100,0]);
    end

end

