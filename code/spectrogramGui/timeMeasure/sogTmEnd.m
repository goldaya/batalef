function [ measurement ] = sogTmEnd( hObject, eventdata, handles )
%SOGTMEND Summary of this function goes here
%   Detailed explanation goes here

    global control;
    [~,tmPushButton] = sogGetHandles( 'pbTimeMeasure' );

    control.sog.tm.on = false;
    
    
    % clear axes functions
    sogAssignAxesFunctions('','');
       
    % output time interval
    measurement = (control.sog.tm.endTime - control.sog.tm.startTime)*1000;
    icon = get(tmPushButton, 'CData');
    msgbox(strcat([num2str(measurement),' msec']),'Time Interval','Custom',icon);


end

