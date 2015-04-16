function cgPlotSpectrogram(  )
%CGPLOTSPECTROGRAM Summary of this function goes here
%   Detailed explanation goes here

    global control;
    handles = cgGetHandles();


    S = control.cg.call.Spectrograma;
    
    % plot spectrogram
    if ismatrix(S.P)
        try
            control.cg.spectrogramSurf = surf(handles.axesWindowSpec,S.T,S.F,S.P,'edgecolor','none');
            axis(handles.axesWindowSpec, 'tight');

            Zlim = get(handles.axesWindowSpec, 'ZLim');
            Ylim = get(handles.axesWindowSpec, 'YLim');
            
            R = control.cg.call.Ridge;
            if ~isempty(R)
                X = R(:,1);
                Y = R(:,2);                
                Z = zeros(length(X),1) + Zlim(2);
                hold(handles.axesWindowSpec,'on');
                plot3(handles.axesWindowSpec,X,Y,Z,'LineWidth',2,'Color','white');
                hold(handles.axesWindowSpec, 'off');
            end
            
            startT = control.cg.call.StartTime;
            endT = control.cg.call.EndTime;
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
    else
        cla(handles.axesWindowSpec);
    end

end

