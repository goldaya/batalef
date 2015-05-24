function [ interpolated ] = calculateBeam( k,a, withSave )
%CALCULATEBEAM Summary of this function goes here
%   Detailed explanation goes here

    
    % default is with save
    if ~exist('withSave','var')
        withSave = true;
    end
    
    
    xBat = fileCallData(k,a,'Location');
    if size(xBat)==[1,3]
        % OK
    elseif size(xBat)==[3,1]
        xBat = transpose(xBat);
    else
        throw(MException('bats:fileCall:location','bat location at file call is not 3d vector'));
    end
    
    M = fileData(k,'Mics','Positions');
    G = fileData(k,'Mics','Gains','NoValidation',true);
    micsBeamUsage = fileData(k,'Mics','BeamUsage','NoValidation',true);
    D = fileData(k,'Mics','Directivity','NoValidation',true);

    
    % air absorption
    channelCalls = fileCallData(k,a,'ChannelCalls');    
    FR = channelCallData(k,1,channelCalls(1),'Peak','Freq');
    TM = getParam('airAbsorption:temperature');
    RH = getParam('airAbsorption:relativeHumidity');
    AP = getParam('airAbsorption:atmosphericPressure');
    [alpha, alpha_iso, c, c_iso] = air_absorption(FR,TM,RH,AP);
    
    % directivity
    if D.use
        % interpolate frequency's function by angle - get on angle-gain
        % vector for the specific frequency
        nD = length(D.cell{1});
        dAngles = zeros(nD,1);
        dGains  = zeros(nD,1);
        dFR     = FR/1000;
        for i = 1:nD
            dAngles(i) = str2double(D.cell{1}{i});
            vF = D.cell{2}{i}{1}; % frequencies
            vG = D.cell{2}{i}{2}; % gain levels
            if length(vF) < 2
                dGains(i) = vG(1);
            else
                dGains(i) = interp1(vF,vG,dFR,'linear','extrap');
            end
        end
        
    end    
    
    % P at mics
    Pm = fileCallData(k,a,'Value','Position','Peak','CallDataType','forBeam');
    
    % get spheric relative 
    n = size(M,1);
    Pg = zeros(n,1);    % power after gain compensation
    Pd = zeros(n,1);    % power after directionality 
    Ps = zeros(n,1);    % power ready for interp
    Cs = zeros(n,3);
    for j = 1:n
        % spheric coordinates
        x = M(j,1) - xBat(1);
        y = M(j,2) - xBat(2);
        z = M(j,3) - xBat(3);
        [az,el,r] = cart2sph(x,y,z);
        Cs(j,1) = az;
        Cs(j,2) = el;
        Cs(j,3) = r;
        
        % gain compensation
        Pg(j) = Pm(j)*G(j)*10^(-r*alpha_iso/10);
        Ps(j) = Pg(j);
        
        % directivity
        if D.use && Ps(j) > 0
            % find angle for mic
            dAngle = rad2deg(ang([-x,-y,-z],D.zero));
            dGain = interp1(dAngles,dGains,dAngle);    
            Ps(j) = Ps(j)*10^((dGain)/10);
            Pd(j) = Pm(j)*10^((dGain)/10);
        end
    end

    % get the center of the mic array
    Cmc = mean(M) - xBat; % Cartesizn center of mass
    [az,el,~] = cart2sph(Cmc(1),Cmc(2),Cmc(3));
    
    % redirect spheric coordinates to center of mass
    g = ones(n,1);
    G = g * [az,el,0];
    Csr = Cs - G;
    
    %
    AZ = 0-radtodeg(Csr(:,1));
    EL = radtodeg(Csr(:,2));
   
    interpolated = calculateBeamInner(k,a,micsBeamUsage,AZ,EL,Pm,Pg,Pd,Ps,withSave);
end

