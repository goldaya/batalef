function mcgParamsDialog(  )
%MCGPARAMSDIALOG INTERNAL

    D = cell(4,1);
    D{1} = num2str(getParam('mics:minimalN'));
    D{2} = num2str(getParam('mics:depth:X'));
    D{3} = num2str(getParam('mics:depth:Y'));
    D{4} = num2str(getParam('mics:depth:Z'));
    
    Q = cell(4,1);
    Q{1} = 'Minimal number of mics';
    Q{2} = 'Minimal relative depth of mics array: X';
    Q{3} = 'Minimal relative depth of mics array: Y';
    Q{4} = 'Minimal relative depth of mics array: Z';
    
    title = '3D localization - mics array parameters';
    
    A = inputdlg(Q,title,[1,100],D);
    
    if ~isempty(A)
        setParam('mics:minimalN',str2double(A{1}));
        setParam('mics:depth:X',str2double(A{2}));
        setParam('mics:depth:Y',str2double(A{3}));
        setParam('mics:depth:Z',str2double(A{4}));
    end

end

