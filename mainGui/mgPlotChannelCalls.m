function [  ] = mgPlotChannelCalls( k,j,axesName )
%MGPLOTCHANNELCALLS Summary of this function goes here
%   Detailed explanation goes here

    global c;
    global control;
    
    if isfield(control.mg.callsMarks, axesName)
        if ishandle(control.mg.callsMarks.(axesName))
            delete(control.mg.callsMarks.(axesName));
            control.mg.callsMarks.(axesName) = [];
        end
    end
    
    if isfield(control.mg.callsNumbers, axesName)
        if ishandle(control.mg.callsNumbers.(axesName))
            delete(control.mg.callsNumbers.(axesName));
            control.mg.callsNumbers.(axesName) = [];
        end
    end
    
    if k==0 || j==0
        return;
    end

    if getParam('mainGUI:showCalls') > c.no && ...
            channelData(k,j,'Calls','Count') > 0

        [~,V,T] = channelData(k,j,'Calls','Detections');
        [~,axobj] = mgGetHandles(axesName);
        axes(axobj)
        hold on;
        control.mg.callsMarks.(axesName) = plot(T,V,'r*');
        set(control.mg.callsMarks.(axesName),'ButtonDownFcn',@mgMpClick);
        if getParam('mainGUI:showCalls') == c.numbered
            I = strtrim(cellstr(num2str(transpose(1:length(T)))));
            control.mg.callsNumbers.(axesName) = text(T,V+0.05,I);
            set(control.mg.callsNumbers.(axesName),'ButtonDownFcn',@mgMpClick);
        end        
        hold off;
    end

end

