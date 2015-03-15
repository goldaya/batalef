function rc = mcgSave(  )
%MCGSAVE Summary of this function goes here
%   Detailed explanation goes here

    global filesObject;
    global control;
    
    [~,micsTableObj] = mcgGetHandles('tableMics');
    D = get(micsTableObj,'Data');
    
    U = cell2mat(D(:,1:2));
    P = cell2mat(D(:,3:5));
    G = cell2mat(D(:,6));
    % check localization usability
    [rc, L] = checkMicsArrayForLocalization(P,U(:,1));
    switch rc
        case 0
            cont = 'Yes';
        case 1
            Q = ['The number of usable mics is lower than requested. ',...
                'This is unsupported by the "Flight Path & Beam" gui. ',...
                '(You can change the criteria through Parameters->Set Parameters)',...
                'Are you sure you want to continue?'];
            cont = questdlg(strcat(Q),'Localization - Mics Array Problem','Yes','No','Yes');
        case 2
            Q = ['The usable sub-array is too flat. ',...
                'This is unsupported by the "Flight Path & Beam" gui. ',...
                '(You can change the criteria through Parameters->Set Parameters)',...
                'Are you sure you want to continue?'];
            cont = questdlg(strcat(Q),'Localization - Mics Array Problem','Yes','No','Yes');            
    end
    if strcmp('Yes',cont)
        rc = 0;
    else
        return;
    end
    
    M = [U,P,G];
    
    K = control.mcg.K;
    for i = 1:length(K)
        filesObject(K(i)).mics.matrix = M;
        filesObject(K(i)).mics.subarrays = L;
    end
    
    if ishandle(control.fpg.fig)
        fpgRefreshBaseChannels();
        fpgRefresh(control.fpg.a);
    end

end