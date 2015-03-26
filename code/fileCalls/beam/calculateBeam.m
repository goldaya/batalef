function [ interpolated ] = calculateBeam( k,a, withSave )
%CALCULATEBEAM Summary of this function goes here
%   Detailed explanation goes here

    global filesObject;
    
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
    U = fileData(k,'Mics','BeamUsage','NoValidation',true);
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
        % direction on each mic
        % D.zero is direction zero of all mics
        [dZeroAzimuth, dZeroElevation,~] = cart2sph(D.zero(1),D.zero(2),D.zero(3));
        
        % interpolate frequency's function by angle - get on angle-gain
        % vector for the specific frequency
        nD = length(D.cell{1});
        dAngle = zeros(nD,1);
        dGain  = zeros(nD,1);
        dFR    = FR/1000;
        for i = 1:nD
            dAngle(i) = str2double(D.cell{1}{i});
            vF = D.cell{2}{i}{1}; % frequencies
            vG = D.cell{2}{i}{2}; % gain levels
            dGain(i) = interp1(vF,vG,dFR);
        end
        
    end    
    
    % P at mics
    Pm = fileCallData(k,a,'Value','Position','Peak');
    
    % get spheric relative 
    n = size(M,1);
    Ps = zeros(n,1);
    Cs = zeros(n,3);
    for j = 1:n
        x = M(j,1) - xBat(1);
        y = M(j,2) - xBat(2);
        z = M(j,3) - xBat(3);
        [az,el,r] = cart2sph(x,y,z);
        Cs(j,1) = az;
        Cs(j,2) = el;
        Cs(j,3) = r;
        %Ps(j) = Pm(j)*G(j)*r^2*(10^(r*alpha_iso/10));
        Ps(j) = Pm(j)*G(j)*10^(-r*alpha_iso/10);
        
        % directivity
        if D.use && Ps(j) > 0
            % -x,-y,-z are the bat location with respect to each mic
            [dBatAzimuth, dBatElevation,~] = cart2sph(-x,-y,-z);

            % find angles (Azimuth & Elevation) for each mic
            dAzimuth   = abs(rad2deg(dZeroAzimuth - dBatAzimuth));   
            dElevation = abs(rad2deg(dZeroElevation - dBatElevation));            
            gAzimuth   = interp1(dAngle,dGain,dAzimuth);
            gElevation = interp1(dAngle,dGain,dElevation);
            Ps(j) = Ps(j)*10^((gAzimuth+gElevation)/10);
        end
    end

    % get the center of the mic array
    Cmc = mean(M) - xBat; % Cartesizn center of mass
    [az,el,r] = cart2sph(Cmc(1),Cmc(2),Cmc(3));
    
    % redirect spheric coordinates to center of mass
    g = ones(n,1);
    G = g * [az,el,0];
    Csr = Cs - G;
    
    %
    AZ = 0-radtodeg(Csr(:,1));
    EL = radtodeg(Csr(:,2));
   
    U = logical(U.*Pm);
    
    Ps = Ps(U);
    AZU = AZ(U);
    ELU = EL(U);
    
    leads = [AZU,ELU,Ps];
    
    
    [raw, interpolated, azCoors, elCoors] = bmAdminCompute( Ps, [AZU, ELU] );
    %raw = 10*log10(raw);
    %interpolated = 10*log10(interpolated);
    if withSave
        filesObject(k).fileCalls{a}.beam.coordinates = [azCoors,elCoors];
        filesObject(k).fileCalls{a}.beam.leads = leads;
        filesObject(k).fileCalls{a}.beam.raw = raw;
        filesObject(k).fileCalls{a}.beam.interpolated = interpolated;
        filesObject(k).fileCalls{a}.beam.micDirections = [AZ,EL];
    end
        
end