function cgShowCall( refreshRawData )
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
    control.cg.wip    = channelCall.inPoints(control.cg.call,window);
    control.cg.window = control.cg.wip./control.cg.call.Fs;
    
    % refresh raw data and filter if needed
    if refreshRawData
        [TS,T] = channelData(control.cg.k,control.cg.j,'TS','Filter',control.cg.filter);
        control.cg.TS = TS;
        control.cg.T  = T;
    end
    
    dataset = control.cg.TS(control.cg.wip(1):control.cg.wip(2));
    
    % recalculate call boundries
    if control.cg.mode == c.process
        % calculate call data from GUI !
        %[~,dataset,T] = cgCalculateCall();
        cgCalculateCall(dataset);
    else
        %dataset = [];
        %T = [];
    end
    
    % put on gui
    cgPlotsAndStats();

end

