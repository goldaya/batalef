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
    
    % air absorption
    channelCalls = fileCallData(k,a,'ChannelCalls');    
    FR = channelCallData(k,1,channelCalls(1),'Peak','Freq');
    TM = getParam('airAbsorption:temperature');
    RH = getParam('airAbsorption:relativeHumidity');
    AP = getParam('airAbsorption:atmosphericPressure');
    [alpha, alpha_iso, c, c_iso] = air_absorption(FR,TM,RH,AP);
    
    % P at mics
    Pm = fileCallData(k,a,'Value','Position','Peak');
    
    % P at source
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
    
    Ps = Ps(U);
    AZU = AZ(U);
    ELU = EL(U);
    
    leads = [AZU,ELU,Ps];
    
    % keep data in filesObject
    
    [raw, interpolated, azCoors, elCoors] = bmAdminCompute( Ps, [AZU, ELU] );
    if withSave
        filesObject(k).fileCalls{a}.beam.coordinates = [azCoors,elCoors];
        filesObject(k).fileCalls{a}.beam.leads = leads;
        filesObject(k).fileCalls{a}.beam.raw = raw;
        filesObject(k).fileCalls{a}.beam.interpolated = interpolated;
        filesObject(k).fileCalls{a}.beam.micDirections = [AZ,EL];
    end
        
end