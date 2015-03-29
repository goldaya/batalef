function [  ] = fpgInit( k )
%FPGINIT -INTERNAL- initializiation script for flight path & beam gui


    global control;
    
    % keep file index
    control.fpg.k = k;

    
    % build base channels list
    fpgRefreshBaseChannels();

    % create uitable
    fpgInitUitab( control.fpg.fig );
    
    % build def methods lists
    bmAdminBuildList( control.fpg.fig );
    bmAdminMethodSelectedInternal(control.beam.method, true);
    
    % refresh all other data
    control.fpg.a = 0;
    fpgRefresh( 0 );
    
end

