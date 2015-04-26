function done = cgSave( call, handles )
%CGSAVE -INTERNAL- Save channel call data by processing type

    vF = get(handles.cbFeatures, 'Value');
    vL = get(handles.cbLocalization, 'Value');
    vB = get(handles.cbBeam, 'Value');

    % check at least one checkbox is on
    if ~vF && ~vL && ~vB
        msgbox('No processing type (Features Extraction, For Localization, or For Beam)');
        done = false;
        return;
    end


    if vF
        call.Type = 'features';
        call.save();
    end

    if vL
        call.Type = 'forLocalization';
        call.save();
    end

    if vB
        call.Type = 'forBeam';
        call.save();
    end

    call.Type = 'features';
    done = true;


end

