function P = fileCallPowersMatrix( fobj,xBat,seq )
%FILECALLPOWERSMATRIX Compute the power at mic at several process points
%(measured, after directivity, ...)


        %{
        measured at mic
        peak freq
        after gain normalization
        after air absorption
        after directionality
        after g+a
        after g+d
        after g+d+a
        to use for beam <-editable
        %}
        P = struct;
        MG = fobj.MicData.GainVector;
        MP = fobj.MicData.Positions;
        MD = fobj.MicData.Directionality;
        
        TM = agetParam('airAbsorption_temperature');
        RH = agetParam('airAbsorption_relativeHumidity');
        AP = agetParam('airAbsorption_atmosphericPressure');
        z = MD.Zero/norm(MD.Zero);

        for j=1:length(seq)
            if seq(j) == 0
                P(j).measured           = NaN;
                P(j).freq               = NaN;
                P(j).distMicBat         = NaN;
                P(j).airAbsorbAmplif    = NaN;
                P(j).angle              = NaN;
                P(j).directAmplif       = NaN;
                P(j).micAmplif          = NaN;
                P(j).power2use          = NaN;
            else
                P(j).measured = fobj.ChannelCalls{j}.forBeam(seq(j),8); % power at peak
                P(j).freq = fobj.ChannelCalls{j}.forBeam(seq(j),7)/1000; % freq at peak
                P(j).distMicBat = norm(xBat-MP(j,:));
                % air absorption
                [~, alpha] = air_absorption(P(j).freq*1000,TM,RH,AP);
                P(j).airAbsorbAmplif = -alpha*P(j).distMicBat;
                % directionality
                if MD.Manage
                    % find angle between bat and mic zero vector (from mic
                    % admin gui)
                    b = xBat-MP(j,:);
                    n = b/norm(b);
                    P(j).angle = rad2deg(acos(dot(n,z)));
                    P(j).directAmplif = fobj.MicData.directionalGain(P(j).angle,P(j).freq);
                else
                    P(j).angle = NaN;
                    P(j).directAmplif = NaN;
                end
                % mic gain amplification
                P(j).micAmplif = MG(j);
                
                % power 2 use in beam computation
                P(j).power2use = P(j).measured - P(j).airAbsorbAmplif - P(j).micAmplif - P(j).directAmplif;
            end
        end

end

