function [  ] = mpgPlot( j, tc, vc )
%MPGPLOT 

    global control;
    handles = mpgGetHandles();
    control.mpg.j  = j;
    control.mpg.tc = tc;
    control.mpg.vc = vc;
    
    
    k = appData('Files','Displayed');
    Fs = fileData(k,'Fs');
    nSamples = fileData(k,'nSamples');
    
    % time window
    It = tc + control.mpg.window.time.*[-1/2,1/2]./1000;
    Ip = round(It.*Fs);
    if Ip(1) < 1
        Ip(1) = 1;
    end
    if Ip(2) > nSamples
        Ip(2) = nSamples;
    end
    control.mpg.Ip = Ip;
    control.mpg.It = It;

    
    % value Window
    Iv = vc + control.mpg.window.value.*[-1/2,1/2];
    
    % get envelope
    [wenv,T] = channelData( k, j, 'Envelope', Ip );
    [wdata]  = abs(channelData(k, j, 'TimeSeries', Ip));
    
    % get local peak
    control.mpg.zoomPeak = [];
    w = warning();          % keep current warning config
    warning('off', 'all');  % suppress all warning    
    [V,L] = findpeaks(wenv, 'MINPEAKHEIGHT',Iv(1) ,'SORTSTR', 'descend');
    warning(w);             % restore warning config
    L = L(V <= Iv(2));
    V = V(V <= Iv(2));
    if ~isempty(V)
        control.mpg.zoomPeak = [ (Ip(1)+L(1))/Fs , V(1) ];
    end
    
    % get existing peaks
    [peaksTimes, peaksValues] = channelData( k, j, 'Calls', 'Detections' );
    peaksValues = peaksValues( peaksTimes >=  It(1) & peaksTimes  <= It(2));
    peaksTimes = peaksTimes(   peaksTimes >=  It(1) & peaksTimes  <= It(2));
    peaksTimes = peaksTimes(   peaksValues >= Iv(1) & peaksValues <= Iv(2));
    peaksValues = peaksValues( peaksValues >= Iv(1) & peaksValues <= Iv(2));
    control.mpg.zoomExistingPeaks.times  = peaksTimes;
    control.mpg.zoomExistingPeaks.values = peaksValues;    
    
    % plot
    plot(handles.axes1, T, wdata, 'Color', [0.6 0.6 0.6]);
    hold(handles.axes1, 'on');
    plot(handles.axes1, T, wenv, 'b');
    if ~isempty(control.mpg.zoomPeak)
        control.mpg.hMark = plot(handles.axes1, control.mpg.zoomPeak(1), control.mpg.zoomPeak(2), 'g*');
    end
    control.mpg.hExisting = plot(handles.axes1, peaksTimes, peaksValues, 'r*');
    hold(handles.axes1, 'off');
    set(handles.axes1, 'xLim', It);
    set(handles.axes1, 'yLim', Iv);  
    
    control.mpg.k = k;
    control.mpg.j = j;
    
    control.mpg.mark = [];
    
    % hide ticks
    set(handles.axes1,'xtick',[])
    set(handles.axes1,'xticklabel',[])
    set(handles.axes1,'ytick',[])
    set(handles.axes1,'yticklabel',[]) 

end

