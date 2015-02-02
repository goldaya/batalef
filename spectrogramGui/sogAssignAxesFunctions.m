function [  ] = sogAssignAxesFunctions( motionFunc, clickFunc )
%SOGASSIGNAXESFUNCTIONS Assign functions for cursor motion and click for
%axes objects

    
    global control;
    handles = sogGetHandles();
    nAxes = appData('Axes','Count');
  
    S=[];
    if isempty(motionFunc)
        set(control.sog.fig,'windowbuttonmotionfcn','')
    else
        S.fh = control.sog.fig;
        for i = 1:nAxes
            axesName = strcat('axes',num2str(i));
            axobj = handles.(axesName);
            obj.handle = axobj;
            obj.AXP = getpixelposition(axobj);
            obj.callback = motionFunc;
            S.objs(i) = obj;
            %axChild = get(axobj,'Children');
            %obj.handle = axChild(1);
            %S.objs(i+nAxes) = obj;
        end
        % Set the motion detector.
        set(S.fh,'windowbuttonmotionfcn',{@axesMousePosition,S}) 
    end

    for i = 1:nAxes
        axesName = strcat('axes',num2str(i));
        axobj = handles.(axesName);
        set(axobj,'ButtonDownFcn',clickFunc);
        if isfield(control.sog, 'tsPlots') && isfield(control.sog.tsPlots,axesName) && ishandle(control.sog.tsPlots.(axesName))
            set(control.sog.tsPlots.(axesName),'ButtonDownFcn',clickFunc);
        end
    end
    
end

