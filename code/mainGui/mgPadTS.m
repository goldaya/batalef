function mgPadTS( K )
%MGPADTS Add parts of the TS

    global control;
    
    
    if isempty(K)
        return;
    end
    
    % ask params
    Q{1} = 'Before beginning of TS [msec]';
    Q{2} = 'After end of TS [msec]';
    D{1} = '0';
    D{2} = '0';
    
    A = inputdlg(Q,'Pad TS',[1,50],D);
    if isempty(A)
        return;
    end
    
    a1 = str2double(A{1});
    a2 = str2double(A{2});
    
    if a1 == 0 && a2 == 0
        return;
    elseif a1 == a2 % and are both > 0
        for ik = 1:length(K)
            padTS(K(ik),a1/1000,true,true,false);
        end
    else
        if a1 > 0
            for ik = 1:length(K)
                padTS(K(ik),a1/1000,true,false,false);
            end
        end
        if a2 > 0
            for ik = 1:length(K)
                padTS(K(ik),a2/1000,false,true,false);
            end        
        end
    end
    
    
    lockZoom = control.mg.lockZoom;
    control.mg.lockZoom = 0;
    mgRefreshAxes();
    control.mg.lockZoom = lockZoom;
    mgRefreshFilesTable();


end

