function mgTrimTS( K )
%MGTRIMTS Cut parts of the TS out
    
    global control;
    
    
    if isempty(K)
        return;
    end
    
    % ask params
    Q{1} = 'From beginning of TS [msec]';
    Q{2} = 'From end of TS [msec]';
    D{1} = '0';
    D{2} = '0';
    
    A = inputdlg(Q,'Trim TS',[1,50],D);
    if isempty(A)
        return;
    end
    
    a1 = str2double(A{1});
    if a1 > 0
%         if length(k) == 1
%             [loseChannelCalls,loseFileCalls]=removeStartTS( K, a1, true );
            
        for ik = 1:length(K)
            removeStartTS( K(ik), a1/1000, false );
        end
    end
    
    a2 = str2double(A{2});
    if a2 > 0
%         if length(k) == 1
%             [loseChannelCalls,loseFileCalls]=removeEndTS( K, a1, true );
            
        for ik = 1:length(K)
            removeEndTS( K(ik), a2/1000, false );
        end        
    end
    lockZoom = control.mg.lockZoom;
    control.mg.lockZoom = 0;
    mgRefreshAxes();
    control.mg.lockZoom = lockZoom;
    mgRefreshFilesTable();

end

