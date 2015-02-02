function [  ] = mgAssignAxesFunctions( motionFunc, clickFunc )
%MGASSIGNAXESFUNCTIONS Assign functions for cursor motion and click for
%axes objects

    
    global control;
    handles = mgGetHandles();
    nAxes = appData('Axes','Count');
  
    
    if isempty(motionFunc)
        set(control.mg.fig,'windowbuttonmotionfcn','')
    else
        S.fh = control.mg.fig;
        for i = 1:nAxes
            axesName = strcat('axes',num2str(i));
            axobj = handles.(axesName);
            obj.handle = axobj;
            obj.AXP = get(axobj,'Position');
            obj.callback = motionFunc;
            S.objs(i) = obj;
        end
        % Set the motion detector.
        set(S.fh,'windowbuttonmotionfcn',{@axesMousePosition,S}) 
    end

    for i = 1:nAxes
        axesName = strcat('axes',num2str(i));
        axobj = handles.(axesName);
        set(axobj,'ButtonDownFcn',clickFunc);
        if isfield(control.mg, 'tsPlots') && isfield(control.mg.tsPlots,axesName) && ishandle(control.mg.tsPlots.(axesName))
            set(control.mg.tsPlots.(axesName),'ButtonDownFcn',clickFunc);
        end
        if isfield(control.mg.callsMarks, axesName)
            if ishandle(control.mg.callsMarks.(axesName))
                set(control.mg.callsMarks.(axesName),'ButtonDownFcn',clickFunc);
            end
        end
    
        if isfield(control.mg.callsNumbers, axesName)
            if ishandle(control.mg.callsNumbers.(axesName))
                set(control.mg.callsNumbers.(axesName),'ButtonDownFcn',clickFunc);
            end
        end

    end
    

end

