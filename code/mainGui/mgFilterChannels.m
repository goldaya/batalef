function [  ] = mgFilterChannels( ask, doFilter, refresh )
%MGFILTERCHANNELS Summary of this function goes here
%   Detailed explanation goes here

    global control;
    handles = mgGetHandles();

    if ask
        title = 'Filter Channels to display';
        Q{1} = 'Provide channels to use, e.g. "1,2", "1,4:7"';
        D{1} = num2str(appData('Channels','Filter'));
        A = inputdlg(Q,title,[1,70],D);
        if isempty(A)
            return;
        else
            filter = str2num(A{1});
        end
    else
        if ~doFilter
            filter = [];
        elseif isvector(doFilter)
            filter = doFilter;
        else
            return;
        end
    end
    
    % set checkmarks in the settings menu
    if isempty(filter);
        set(handles.settingsFilterMenuItem, 'Checked', 'off');
        set(handles.settingsNofilterMenuItem, 'Checked', 'on');
    else
        set(handles.settingsFilterMenuItem, 'Checked', 'on');
        set(handles.settingsNofilterMenuItem, 'Checked', 'off');
    end
    
    % keep filter
    control.mg.channelsFilter = filter;
    
    % refresh axes plots
    if ~exist('refresh','var') || refresh
        mgRefreshDisplay();
    end
        

end

