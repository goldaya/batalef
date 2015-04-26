function cgShowCall(  )
%CGSHOWCALL -INTERNAL- show call on gui


    global control;
    global c;
    handles = cgGetHandles();
    
    % display vs. processing mode
    if control.cg.mode == c.display

        % when in display mode, get the right proc type
        if get(handles.rbFeatures,'Value')
            control.cg.t = 'features';
        elseif get(handles.rbLocalization,'Value')
            control.cg.t = 'forLocalization';
        elseif get(handles.rbBeam,'Value')
            control.cg.t = 'forBeam';
        else
            throw(MException('bats:channelCall:procType','Wrong processing type'));
        end
        
    else
        control.cg.t = 'features';
    end
    
    % get the right call
    control.cg.call = channelCall(control.cg.k,control.cg.j,control.cg.s,control.cg.t,false);
  
    % window to work in
    dt = str2double(get(handles.textCallWindow, 'String'))/1000 ;
    window = control.cg.call.DetectionTime + ([-0.5, 0.5].*dt);
    control.cg.window = window;
    
    % recalculate call boundries
    if control.cg.mode == c.process
        % calculate call data from GUI !
        [~,dataset,T] = cgCalculateCall();
    else
        dataset = [];
        T = [];
    end
    
    % put on gui
    cgPlotsAndStats(dataset,T);

end

