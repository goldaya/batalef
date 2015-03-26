function rc = mcgSave(  )
%MCGSAVE Summary of this function goes here
%   Detailed explanation goes here

    global filesObject;
    global control;
    
    handles = mcgGetHandles();
    Data = get(handles.tableMics,'Data');
    
    U = cell2mat(Data(:,1:2));
    P = cell2mat(Data(:,3:5));
    G = cell2mat(Data(:,6));
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
    
    % array depth
    V = str2num(get(handles.textMinDepth,'String'));
    setParam('mics:depth:X',V(1));
    setParam('mics:depth:Y',V(2));
    setParam('mics:depth:Z',V(3));
    N = str2double(get(handles.textMinN,'String'));
    setParam('mics:minimalN',N);    
    
    % directivity
    D.use = get(handles.cbManageDirectivity,'Value');
    D.zero = str2num(get(handles.textZeroVector,'String'));
    if isempty(D.zero) || length(D.zero) ~= 3
        msgbox('Error in directivity zero vector');
        return;
    end
    Dmat = get(handles.tableDirectivity,'Data');
    nan = cell2mat(cellfun(@(x) isempty(x)||isnan(x),Dmat,'UniformOutput',false));
    Dmat(all(nan,2),:) = [];
    nan(all(nan,2),:) = [];
    if max(max(nan)) > 0
        msgbox('Error in directivity matrix');
        return;
    end
    D.matrix = Dmat;
    
    % keep freq-gain vector for each angle
    C = cell(1,2);
    for i = 1:size(Dmat,1)
        % cellIdx is the angle index for specific 
        cellIdx = find(strcmp(num2str(Dmat{i,2}), C{1}));
        if isempty(cellIdx)
            cellIdx = length(C{1}) + 1;
            C{1}{cellIdx} = num2str(Dmat{i,2});
            C{2}{cellIdx} = cell(1,2);
            C{2}{cellIdx}{1} = zeros(1,1);
            C{2}{cellIdx}{2} = zeros(1,1);
            n = 0;
        else
            n = length(C{2}{cellIdx}{1});
        end
        
        % the freq-gain vector for specific angle
        C{2}{cellIdx}{1}(n+1)=Dmat{i,1}; % freq
        C{2}{cellIdx}{2}(n+1)=Dmat{i,3}; % gain
    end
    D.cell = C;
    
    %{
    V = str2num(get(hObject,'String'));
    setParam('mics:zero:X',V(1));
    setParam('mics:zero:Y',V(2));
    setParam('mics:zero:Z',V(3));
    %}
    
    K = control.mcg.K;
    for i = 1:length(K)
        filesObject(K(i)).mics.matrix = M;
        filesObject(K(i)).mics.subarrays = L;
        filesObject(K(i)).mics.directivity = D;
    end
    
    if ishandle(control.fpg.fig)
        fpgRefreshBaseChannels();
        fpgRefresh(control.fpg.a);
    end

end