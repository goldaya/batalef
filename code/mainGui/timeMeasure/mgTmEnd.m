function [ output_args ] = mgTmEnd( hObject, eventdata, handles )
%MGTMEND Summary of this function goes here
%   Detailed explanation goes here

    global control;
    [~,tmPushButton] = mgGetHandles( 'pbTimeMeasure' );

    % clear axes functions
    mgAssignAxesFunctions('','');
    
    % output time interval
    measurement = (control.mg.tm.endTime - control.mg.tm.startTime)*1000;
    icon = get(tmPushButton, 'CData');
    msgbox(strcat([num2str(measurement),' msec']),'Time Interval','Custom',icon);


end

