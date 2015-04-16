function [  ] = cgRefresh(  )
%CGREFRESH Refresh all sliders, plots and stuff


    global control;
    handles = cgGetHandles();
    
   
    if get(handles.rbValuesCalculated, 'Value') || ( get(handles.rbValuesMix,'Value') && ~control.cg.call.Saved )
        % calculate call data from GUI !
        cgCalculateCall();
    end
    
    cgPlot();
    
end

