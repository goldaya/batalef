function [  ] = ccdmAdminMethodSelected( hObject, eventdata, handles )
%CCDMADMINMETHODSELECTED Summary of this function goes here
%   Detailed explanation goes here

    K = mgResolveFilesToWork();
    if isempty(K)
        return;
    end
    
    i = get(hObject, 'UserData');
    channelCallsDetectionMethods;
    [mpars, userAbort] = defMethodsParamsDialog( m{i}{3}, m{i}{1});
    if userAbort
        return;
    end
    if strcmp(mpars.replace,'Replace')
        mpars.replace = true;
    end
    
    mfunc = str2func(m{i}{2});

    j = str2double(mpars.channels);
    for i = 1 : length(K)
        Fs = fileData(K(i),'Fs');
        n = fileData(K(i),'Channels','Count');
        if isnan(j) % no channel specific
            dataset = fileData(K(i),'TS');
            CA = mfunc(dataset, Fs, mpars);
            for j = 1:n
                calls = CA{j};
                addChannelCalls(K(i),j,[calls.points,calls.values],mpars.replace,true);
            end
        elseif j <= n % channel specific
            dataset = channelData(K(i),j,'TS');
            CA = mfunc(dataset, Fs, mpars);
            calls = CA{1};
            addChannelCalls(K(i),j,[calls.points,calls.values],mpars.replace,true);
        end
    end
    
    
    mgRefreshChannelCallsDisplay();
    msgbox('Finished calls detection');
    
end

