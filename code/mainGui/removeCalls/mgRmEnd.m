function [  ] = mgRmEnd( hObject, eventdata, handles )
%MGRMEND 

    global control;

    % clear axes functions
    mgAssignAxesFunctions('','');
    
    % Remove calls in interval
    N = fileData(control.mg.k,'Channels','Count');
    Fs = fileData(control.mg.k, 'Fs');
    for j = 1:N
        removeChannelCalls( control.mg.k, j, 'DetectionBetween', round([control.mg.Rm.startTime,control.mg.Rm.endTime].*Fs) );
    end
    %channelCall_new.removeByTimes([control.mg.Rm.startTime,control.mg.Rm.endTime]);
    
    % remove markers
    mgRmInit(false);
    
    % refresh display
    mgRefreshAxes();

end

