function [ output_args ] = mgSuEnd( hObject, eventdata, handles )
%MGSUEND 

    global control;

    % clear axes functions
    mgAssignAxesFunctions('','');
    
    % call spectro gui
    Fs = fileData(appData('Files','Displayed'),'Fs');
    a = ceil(control.mg.su.startTime * Fs);
    b = ceil(control.mg.su.endTime * Fs);
    spectrumGUI([a,b]);

end

