function [  ] = mgRmEnd( hObject, eventdata, handles )
%MGRMEND 

    global control;

    % clear axes functions
    mgAssignAxesFunctions('','');
    
    % Remove calls in interval
    N = fileData(control.mg.k,'Channels','Count');
    for j = 1:N
        channelCall.removeCalls( control.mg.k, j, [control.mg.Rm.startTime,control.mg.Rm.endTime] );
    end
    %channelCall_new.removeByTimes([control.mg.Rm.startTime,control.mg.Rm.endTime]);
    
    % remove markers
    mgRmInit(false);
    
    % refresh display
    mgRefreshAxes();

end

