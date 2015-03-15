function cgPlotSpectrogram(  )
%CGPLOTSPECTROGRAM Summary of this function goes here
%   Detailed explanation goes here

    global control;
    handles = cgGetHandles();

    [a,b] = cgGetPlotingPoints();
    try
        [F,T,P,startT, endT] = control.cg.call.computeSpectralData([a,b]);
        doPlot = true;
    catch err
        cla(handles.axesWindowSpec);
        doPlot = false;
    end
    
    if doPlot
    R = control.cg.call.Ridge;
    if ~isempty(R)
        X = R(:,1);
        Y = R(:,2);
        plotRidge = true;
    else
        plotRidge = false;
    end
    
    % plot spectrogram
    if ismatrix(P)
        try
            control.cg.spectrogramSurf = surf(handles.axesWindowSpec,T,F,P,'edgecolor','none');
            axis(handles.axesWindowSpec, 'tight');

            Zlim = get(handles.axesWindowSpec, 'ZLim');
            Ylim = get(handles.axesWindowSpec, 'YLim');
            
            if plotRidge
                Z = zeros(length(X),1) + Zlim(2);
                hold(handles.axesWindowSpec,'on');
                plot3(handles.axesWindowSpec,X,Y,Z,'LineWidth',2,'Color','white');
                hold(handles.axesWindowSpec, 'off');
            end
            
            lineStart = line([startT,startT],Ylim,[Zlim(2),Zlim(2)],'LineWidth',3,'Color','white');
            set(lineStart,'Parent',handles.axesWindowSpec);
            lineEnd = line([endT,endT],Ylim,[Zlim(2),Zlim(2)],'LineWidth',3,'Color','white');
            set(lineEnd,'Parent',handles.axesWindowSpec);
            
            view(handles.axesWindowSpec,[0,90]); 
            ylabel(handles.axesWindowSpec, {'Spectrogram','Frequency: Hz'});
            xlabel(handles.axesWindowSpec, {'Time: seconds','Realized call between white markers','Ridge given by thiner white curve'});
        catch err
            err.identifier
            err.message
        end
    end
    end
    
    % put spectral info on screen
    set(handles.textStartFreq, 'String', control.cg.call.StartFreq);
    set(handles.textPeakFreq, 'String', control.cg.call.PeakFreq);
    set(handles.textEndFreq, 'String', control.cg.call.EndFreq);   

end

