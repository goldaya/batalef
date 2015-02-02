function [  ] = mgMpwpdEnd( hObject, eventdata, handles )
%MGSUEND 

    global control;

    % clear axes functions
    mgAssignAxesFunctions('','');
    
    % call peak detection over interval
    Fs = fileData(appData('Files','Displayed'),'Fs');
    a = ceil(control.mg.Mpwpd.startTime * Fs);
    b = ceil(control.mg.Mpwpd.endTime * Fs);
    pwpdgDetectManualInterval( [a,b] )

end

