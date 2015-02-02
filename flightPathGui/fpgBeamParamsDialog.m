function fpgBeamParamsDialog(  )
%FPGBEAMPARAMSDIALOG INTERNAL Calls a dialog to edit the beam comp. related params

    Q{1} = 'Min Azimuth (deg)';
    Q{2} = 'Max Azimuth(deg)';
    Q{3} = 'Azimuth Resolution (deg)';
    Q{4} = 'Min Elevation (deg)';
    Q{5} = 'Max Elevation (deg)';
    Q{6} = 'Elevation Resolution (deg)';
    
    D{1} = num2str(getParam('beam:minAz'));
    D{2} = num2str(getParam('beam:maxAz'));
    D{3} = num2str(getParam('beam:resAz'));
    D{4} = num2str(getParam('beam:minEl'));
    D{5} = num2str(getParam('beam:maxEl'));
    D{6} = num2str(getParam('beam:resEl'));
    
    A = inputdlg(Q,'Beam Computation Parameters',[1,70],D);
    
    if ~isempty(A)
        setParam('beam:minAz',str2double(A{1}));
        setParam('beam:maxAz',str2double(A{2}));
        setParam('beam:resAz',str2double(A{3}));
        setParam('beam:minEl',str2double(A{4}));
        setParam('beam:maxEl',str2double(A{5}));
        setParam('beam:resEl',str2double(A{6}));
    end
    
end

