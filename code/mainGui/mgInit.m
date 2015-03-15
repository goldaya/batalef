global c;

% keep gui figure
global control;
control.mg.fig = hObject;

% draw files table
mgInitTabFiles(control.mg.fig);

% show calls choice
switch getParam('mainGUI:showCalls')
    case c.no
        set(handles.channelCallsShowNoMenuItem, 'Checked', 'on');
        set(handles.channelCallsShowYesMenuItem, 'Checked', 'off');
        set(handles.channelCallsShowNumberMenuItem, 'Checked', 'off');
    case c.yes
        set(handles.channelCallsShowNoMenuItem, 'Checked', 'off');
        set(handles.channelCallsShowYesMenuItem, 'Checked', 'on');
        set(handles.channelCallsShowNumberMenuItem, 'Checked', 'off');        
    case c.numbered
        set(handles.channelCallsShowNoMenuItem, 'Checked', 'off');
        set(handles.channelCallsShowYesMenuItem, 'Checked', 'off');
        set(handles.channelCallsShowNumberMenuItem, 'Checked', 'on');        
end

% no channel filter on startup
set(handles.settingsNofilterMenuItem, 'Checked', 'on');

% display decimation
if getParam('mainGUI:decimateDisplay')
    control.mg.decimateDisplay.p = getParam('decimation:p');
    control.mg.decimateDisplay.q = getParam('decimation:q');
end

% default methods
sumAdminBuildList(control.mg.fig);
sumAdminMethodSelectedInternal(control.spectrum.method, true);
somAdminBuildList(control.mg.fig);
somAdminMethodSelectedInternal(control.spectrogram.method, true);
envmAdminBuildList(control.mg.fig);
envmAdminMethodSelectedInternal(control.envelope.method, true);

ccdmAdminBuildList();