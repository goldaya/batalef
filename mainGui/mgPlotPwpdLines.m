function [  ] = mgPlotPwpdLines( axesName )
%MGPLOTPWPDLINES 

    global control;
    
    if isfield(control.mg, 'pwpdLines') ...
            && isfield(control.mg.pwpdLines, axesName) ...
            && ~isempty(control.mg.pwpdLines.(axesName))
        axesLines = control.mg.pwpdLines.(axesName);
        for i = 1:length(axesLines)
            if ishandle(axesLines(i))
                delete(axesLines(i));
            end            
        end
        control.mg.pwpdLines.(axesName) = [];
    end
        
    if isempty(control.pwpdIntervals)
        return;
    else
        k = appData('Files','Displayed');
        Fs = fileData(k,'Fs','NoValidation',true);
        [~,axobj] = mgGetHandles(axesName);
        I = control.pwpdIntervals./Fs;
        
        axesLines = zeros(2*size(I,1),1);
        [min,max] = fileData(k,'TS','Value','MinMax');
        ylim = [min max];
        
        axes(axobj)
        hold on;
        for i=1:size(I,1)
            axesLines(2*i-1) = line([I(i,1) I(i,1)],ylim, 'Color', [0.5 0.7 0]);
            axesLines(2*i) = line([I(i,2) I(i,2)], ylim, 'Color', [0.9 0.5 0]);
        end
        hold off;
        
        % keep for later manipulation
        control.mg.pwpdLines.(axesName) = axesLines;
        
    end

end

