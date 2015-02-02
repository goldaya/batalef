function [  ] = fpgInit( k )
%FPGINIT Summary of this function goes here
%   Detailed explanation goes here


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
    fpgRefresh( 0 );
    
end

