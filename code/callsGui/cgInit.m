function [ output_args ] = cgInit( input_args )
%CGINIT 

    global control;
    handles = cgGetHandles();
    
    % align gui with main gui
    mgOuter = get(control.mg.fig, 'OuterPosition');
    top = mgOuter(2) + mgOuter(4);
    right = getNextGuiX(handles.figure1);
    pos = get(control.cg.fig, 'Position');
    pos(1) = right;
    pos(2) = top - pos(4) + 10;
    set(control.cg.fig, 'Position', pos);   
    
    % default methods
    somAdminBuildList(control.cg.fig);
    sumAdminBuildList(control.cg.fig);
    envmAdminBuildList(control.cg.fig);
    rdgmAdminBuildList();
    rdgmAdminMethodSelectedInternal(control.ridge.method, true);
    
    % some initial values
    cgRestoreParams();    
    
end

