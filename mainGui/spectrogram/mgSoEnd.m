function [ output_args ] = mgSoEnd( hObject, eventdata, handles )
%MGSOEND 

    global control;

    % clear axes functions
    mgAssignAxesFunctions('','');
    
    % call spectro gui
    Fs = fileData(appData('Files','Displayed'),'Fs');
    a = ceil(control.mg.so.startTime * Fs);
    b = ceil(control.mg.so.endTime * Fs);
    spectrogramGUI([a,b]);
    

end

