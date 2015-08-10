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
%     ctr = diff([min(micPositions);max(micPositions)])./2; % center of mics
%     rel = [micPositions; ctr] - ones(nMics+1,1)*batPosition; % mics relative to bat
%     sph = cart2sph(rel(:,1),rel(:,2),rel(:,3));
%     rel_sph = [sph(1:nMics,1:2) - ones(nMics,1)*sph(nMics+1,:),sph(1:nMics,3)];
    
    
    % radius correction (air absorption)
    R = sqrt(sum((micPositions-ones(nMics,1)*batPosition).^2,2)); % radii
    FR = channelCallData(k,1,channelCalls(1),'Peak','Freq');
    TM = getParam('airAbsorption:temperature');
    RH = getParam('airAbsorption:relativeHumidity');
    AP = getParam('airAbsorption:atmosphericPressure');
    [~, alpha] = air_absorption(FR,TM,RH,AP);    
    rC = 10.^(R.*alpha./10);
    
    % gain calibration 
    gC = fileData(k,'Mics','Gains','NoValidation',true);
    
    % directivity
    D = fileData(k,'Mics','Directivity','NoValidation',true);
    dC = ones(nMics,1);
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

    % POWERS AT MICS
    % measured input power at mics
    pM = zeros(nMics,1);
    for j = 1:nMics
        if ~isnan(channelCalls(j))
            pM(j) = channelCallData(k,j,channelCalls(j),'Peak','Value','CallDataType','forBeam');
        end
    end
    
    %this is attenuation oriented, maybe should be power oriented:
    M = [pM,R,1./rC,gC,gC./rC,dC,dC.*gC./rC,...
        pM./rC,pM.*gC,pM.*gC./rC,pM.*dC,pM.*dC.*gC./rC];
end

