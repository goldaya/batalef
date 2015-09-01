function M = fileCallPowersMatrix( k, batPosition, channelCalls )
%FILECALLPOWERSMATRIX Compute the power at mic at several process points
%(measured, after directivity, ...)

    
    
%     % relative spheric mic positions (from bat perspective, looking to
%     % center of mic array)
    micPositions = fileData(k,'Mics','Positions');
    nMics = size(micPositions,1);
    if ~isrow(batPosition)
        batPosition = batPosition';
    end
    ctr = diff([min(micPositions);max(micPositions)])./2; % center of mics
    rel = [micPositions; ctr] - ones(nMics+1,1)*batPosition; % mics relative to bat
    [AZ,EL,R] = cart2sph(rel(:,1),rel(:,2),rel(:,3));
    rAZ = rad2deg(AZ(1:nMics) - AZ(nMics+1));
    rEL = rad2deg(EL(1:nMics) - EL(nMics+1));
     
    % radius correction (air absorption)
%     R = sqrt(sum((micPositions-ones(nMics,1)*batPosition).^2,2)); % radii
    R = R(1:nMics);
    FR = channelCallData(k,1,channelCalls(1),'Peak','Freq');
    TM = getParam('airAbsorption:temperature');
    RH = getParam('airAbsorption:relativeHumidity');
    AP = getParam('airAbsorption:atmosphericPressure');
    [~, alpha] = air_absorption(FR,TM,RH,AP);    
    gA = - R.*alpha;
%     gA = 10.^(R.*alpha./10);
    
    % gain calibration 
    gC = fileData(k,'Mics','Gains','NoValidation',true);
    gC = 10.*log10(gC);
    
    % directivity
    D = fileData(k,'Mics','Directivity','NoValidation',true);
    dC = zeros(nMics,1);
    angles = zeros(nMics,1);
    if D.use
        angles = arrayfun(@(x) ang(batPosition-x{1},D.zero), ...
            mat2cell(micPositions,ones(1,nMics),3));        
        X = cell2mat(D.cell{1});
        Y = zeros(length(A));
        for i = 1:length(X)
            Y(i) = interp1(D.cell{2}{i}{1},D.cell{2}{i}{1},FR,'linear','extrap');
        end
        dC = arrayfun(@(a) interp(X,Y,a,'linear','extrap'),angles);
    end
    gD = dC; % dB ?

    % POWERS AT MICS
    % measured input power at mics
    pM = zeros(nMics,1);
    for j = 1:nMics
        if ~isnan(channelCalls(j))
            pM(j) = channelCallData(k,j,channelCalls(j),'Peak','Value','CallDataType','forBeam');
        end
    end
    
    %this is attenuation oriented, maybe should be power oriented:
    M = [...
        rAZ,...          % azimuth (mic from bat perspective with zero at center of array)
        rEL,...          % elevation
        R,...            % distance bat-mic
        angles,...       % angle betwen mic direct zero and bat (for directionality)
        pM,...           % measured power at mic
        gA,...           % air absorbtion
        gC,...           % Mic Calibration Gain (dB)
        gD,...           % Mic Directionality Gain (dB)
        pM+gA+gC,...     % Power after Air + Calib.
        pM+gD,...        % Power after Direct.
        pM+gA+gC+gD,...  % Power after all corrections
        ];
end

