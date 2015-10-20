function fcgPlotRaw()
%FCGPLOTRAW Plot the beam 'raw' image

    handles = getHandles('fcg');
    axobj   = handles.axesRaw;
    cla(axobj);
    [k,a] = fcgGetCurrent();
    if a == 0
        return;
    end
    
    % create domain
    domain.azMin = getParam('beam:minAz');
    domain.azMax = getParam('beam:maxAz');
    domain.elMin = getParam('beam:minEl');
    domain.elMax = getParam('beam:maxEl');
    domain.azRes = getParam('beam:resAz');
    domain.elRes = getParam('beam:resEl');
    azCoors = transpose(linspace(domain.azMin,domain.azMax,round((domain.azMax - domain.azMin)/domain.azRes)));
    elCoors = transpose(linspace(domain.elMin,domain.elMax,round((domain.elMax - domain.elMin)/domain.elRes)));
    clear domain;
    
    % get powers matrix
    D = get(handles.uitabPowers,'Data');
    U  = cell2mat(D(:,1));
    AZ = cell2mat(D(:,2));
    EL = cell2mat(D(:,3));
    P  = cell2mat(D(:,11));
    
    M = NaN(length(elCoors),length(azCoors));
    mAZ = zeros(length(U),1);
    mEL = zeros(length(U),1);
    for i = 1:length(P)
        % put in the most appropiate cell
        A = abs(azCoors - AZ(i));
        [~,iAZ] = min(A);
        A = abs(elCoors - EL(i));
        [~,iEL] = min(A);
        M(iEL,iAZ) = P(i);
        mAZ(i) = azCoors(iAZ);
        mEL(i) = elCoors(iEL);
    end

    axes(axobj);
    imagesc(azCoors,elCoors,M,'Parent',axobj);
    set(axobj,'YDir','normal');

    for i = 1:length(U)
%         idx = text(mAZ(i),mEL(i),num2str(i));
        idx = text(AZ(i)+2,EL(i),num2str(i));
        set(idx,'Clipping','on');
        if U(i)
            set(idx,'Color','green');
        else
            set(idx,'Color','red');
        end    
    end
    
end