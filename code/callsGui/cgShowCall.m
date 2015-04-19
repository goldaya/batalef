function cgShowCall(  )
%CGSHOWCALL -INTERNAL- show call on gui


    global control;
    handles = cgGetHandles();
    
    % get the right call
    control.cg.call = channelCall(control.cg.k,control.cg.j,control.cg.s,control.cg.t,false);
  
    % window to work in
    dt = str2double(get(handles.textCallWindow, 'String'))/1000 ;
    window = control.cg.call.DetectionTime + ([-0.5, 0.5].*dt);
    control.cg.window = window;
    
    % recalculate call boundries
    if get(handles.rbValuesCalculated, 'Value')
        % calculate call data from GUI !
        cgCalculateCall();
    end
    
    % put on gui
    cgPlotsAndStats();

end

