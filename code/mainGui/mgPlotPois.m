function mgPlotPois(k,j,axesName)
%MGPLOTPOIS Summary of this function goes here
%   Detailed explanation goes here

    global control;
    
    if isfield(control.mg, 'pois')
    if isfield(control.mg.pois, axesName)
        if ishandle(control.mg.pois.(axesName))
            delete(control.mg.pois.(axesName));
            control.mg.pois.(axesName) = [];
        end
    end
    else
        control.mg.pois = [];
    end
    
    if k==0 || j==0
        return;
    end
    
    pois = channelData(k,j,'Pois');
    if ~isempty(pois)
        [~,axobj] = mgGetHandles(axesName);
        axes(axobj)
        hold on;
        control.mg.pois.(axesName) = plot(pois(:,1),pois(:,2),'g+');
        set(control.mg.callsMarks.(axesName),'ButtonDownFcn',@mgMpClick);
        hold off;
    end
    
end

