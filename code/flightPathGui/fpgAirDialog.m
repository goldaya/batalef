function [ A ] = fpgAirDialog(  )
%FPGAIRDIALOG Summary of this function goes here
%   Detailed explanation goes here
    
    Q = cell(3,1);
    Q{1} = 'Temperature (C)';
    Q{2} = 'Relative Humidity (%)';
    Q{3} = 'Atmospheric Pressure (Atm)';
    
    D = cell(3,1);
    D{1} = num2str(getParam('airAbsorption:temperature'));
    D{2} = num2str(getParam('airAbsorption:relativeHumidity'));
    D{3} = num2str(getParam('airAbsorption:atmosphericPressure'));

    A = inputdlg(Q,'Air Absorption Parameters',[1,70],D);
    
    if ~isempty(A)
        setParam('airAbsorption:temperature', str2double(A{1}));
        setParam('airAbsorption:relativeHumidity', str2double(A{2}));
        setParam('airAbsorption:atmosphericPressure', str2double(A{3}));
    end
    
end

