function [x,dT] = localizeFileCall(fobj,seq)
%LOCALIZEFILECALL compute time diff between channel calls and localize
%using batalef built in methods system
%
%   x = localizeFileCall(fobj,seq)
%

    M = fobj.MicData.Positions;
    U = logical(fobj.MicData.UseInLocalization .* seq'~=0);
    I = find(U);
    Ml = M(U,:);
    
    if length(I) < agetParam('fileCalls_localization_minN')
        dT = [];
        x  = [];
        return;
    end
    
    % cross correlation to find dT
    baseCall = fobj.channel(I(1)).call(seq(I(1)));
    baseCall.loadCall('forLocalization');
    interval = [baseCall.Start.Time,baseCall.End.Time];
    Fs = fobj.Fs;
    TS = fobj.RawData.getTS(I,interval);
    dT = zeros(length(I),1);
    for i = 2:length(I)
        [a,lags] = xcorr(TS(:,i),TS(:,1));
        [~,a2] = max(abs(a));
        dT(i) = lags(a2)/Fs;
    end
    
    % localize
    x = fobj.Application.Methods.fileCallLocalization.execute(dT,Ml,agetParam('defaultSoundSpeed'),struct());

end

