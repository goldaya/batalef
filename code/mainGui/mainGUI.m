function varargout = mainGUI(varargin)
% MAINGUI MATLAB code for mainGUI.fig
%      MAINGUI, by itself, creates a new MAINGUI or raises the existing
%      singleton*.
%
%      H = MAINGUI returns the handle to a new MAINGUI or the handle to
%      the existing singleton*.
%
%      MAINGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAINGUI.M with the given input arguments.
%
%      MAINGUI('Property','Value',...) creates a new MAINGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before mainGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to mainGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help mainGUI

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @mainGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @mainGUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before mainGUI is made visible.
function mainGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to mainGUI (see VARARGIN)

% Choose default command line output for mainGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% init procedure
mgInit;




% --- Outputs from this function are returned to the command line.
function varargout = mainGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
% set gui position and number of sidplayed axes
pause on;
pause(1);
mgInitDisplay();
pause off;
set(hObject,'Visible','on');



% --- Executes on slider movement.
function sliderChannels_Callback(hObject, eventdata, handles)
% hObject    handle to sliderChannels (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
set(hObject, 'Value', round(get(hObject, 'Value')));
mgRefreshAxes();


% --- Executes during object creation, after setting all properties.
function sliderChannels_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function settingsFilterMenuItem_Callback(hObject, eventdata, handles)
mgFilterChannels(true,true,true);

% --------------------------------------------------------------------
function settingsNofilterMenuItem_Callback(hObject, eventdata, handles)
mgFilterChannels(false,false,true);


% --------------------------------------------------------------------
function filesMenu_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function filesAddMenuItem_Callback(hObject, eventdata, handles)
mgAddFiles();


% --- Executes when selected cell(s) is changed in tabFiles.
function tabFiles_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to tabFiles (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)
set(hObject, 'UserData', eventdata.Indices);


% --------------------------------------------------------------------
function tabFiles_ButtonDownFcn(hObject, eventdata, handles)
v = mgResolveFilesToWork();
if ~isempty(v)
    mgDisplayFile(v(1));
end


% --------------------------------------------------------------------
function settingsAddAxesMenuItem_Callback(hObject, eventdata, handles)
mgAddAxes(1);
mgRefreshDisplay();

% --------------------------------------------------------------------
function settingsRemoveAxesMenuItem_Callback(hObject, eventdata, handles)
mgRemoveAxes(1);
mgRefreshDisplay();

% --------------------------------------------------------------------
function settingsSetAxesMenuItem_Callback(hObject, eventdata, handles)
Q{1} = 'Number of Axes objects to display';
D{1} = num2str(appData('Axes','Count'));
A = inputdlg(Q,'',[1,50],D);
if ~isempty(A)
    mgSetAxesNumber(str2double(A{1}));
    mgRefreshDisplay();
end


% --------------------------------------------------------------------
function toggleLinkaxes_OffCallback(hObject, eventdata, handles)
mgLinkAxes(false);
%{
global control;
handles = mgGetHandles();
nAxes = appData('Axes','Count');
for i = 1:nAxes;
    axesName = strcat('axes',num2str(i));
    linkaxes(handles.(axesName));
end
control.mg.linkAxes = false;
%}


% --------------------------------------------------------------------
function toggleLinkaxes_OnCallback(hObject, eventdata, handles)
mgLinkAxes(true);
%{
global control;
handles = mgGetHandles();
nAxes = appData('Axes','Count');
V = zeros(nAxes,1);
for i = 1:nAxes;
    axesName = strcat('axes',num2str(i));
    V(i) = handles.(axesName);
end
linkaxes(V);
control.mg.linkAxes = true;
%}


% --------------------------------------------------------------------
function pbTimeMeasure_ClickedCallback(hObject, eventdata, handles)
global control;
zoom('off');
pan('off');
datacursormode('off');
mgSuInit(false);
mgSoInit(false);
mgTmInit(~control.mg.tm.on);


% --------------------------------------------------------------------
function filesRemoveMenuItem_Callback(hObject, eventdata, handles)
mgRemoveFiles();


% --------------------------------------------------------------------
function pbShowSpectrum_ClickedCallback(hObject, eventdata, handles)
global control;
zoom('off');
pan('off');
datacursormode('off');
mgSoInit(false);
mgTmInit(false);
mgSuInit(~control.mg.su.on);


% --------------------------------------------------------------------
function rdataMenu_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function rdataDecimationMenuItem_Callback(hObject, eventdata, handles)
decimateFiles(mgResolveFilesToWork());
msgbox('Finished decimation');
mgRefreshFilesTable();
mgRefreshDisplay();

% --------------------------------------------------------------------
function rdataFilterMenu_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function rdataWildcardMenuItem_Callback(hObject, eventdata, handles)
[rc, funcName, failed] = applyWildCard(mgResolveFilesToWork());
switch rc
    case 2
        msgbbox('Wildcard function was not applied');
    case 1
        msgbox(strcat(['Wildcard function was partially applied. Failed on: ', seq2string(failed)]));
    case 0
        masgbox('Wild card function applied');
    case 3
        msgbox('No files to work on');
end
mgRefreshFilesTable();
mgRefreshDisplay();

% --------------------------------------------------------------------
function rdataReloadMenuItem_Callback(hObject, eventdata, handles)
loadRawData(mgResolveFilesToWork());
msgbox('Raw data reloaded');
mgRefreshFilesTable();
mgRefreshDisplay();


% --------------------------------------------------------------------
function rdataFilterButterMenuItem_Callback(hObject, eventdata, handles)
[rc, failed] = filterButter(mgResolveFilesToWork());
switch rc
    case 2
        msgbox('Filter not applied');
    case 1
        msgbox(strcat(['Filter failed on: ', seq2string(failed)]));
    case 0
        msgbox('Filter applied');
    case 3
        msgbox('No files to filter');

end
mgRefreshDisplay();


% --------------------------------------------------------------------
function rdataFilterBuilderMenuItem_Callback(hObject, eventdata, handles)
rc = filterBuilder(mgResolveFilesToWork());
switch rc
    case 2
        msgbox('Filter not applied');
    case 1
        msgbox(strcat(['Filter failed on: ', seq2string(failed)]));
    case 0
        msgbox('Filter applied');
    case 3
        msgbox('No files to filter');
end
mgRefreshDisplay();


% --------------------------------------------------------------------
function settingsParamsLoadMenuItem_Callback(hObject, eventdata, handles)
loadParametersFile();

% --------------------------------------------------------------------
function settingsParamsSaveMenuItem_Callback(hObject, eventdata, handles)
global control;
if ~isempty(control.cg.fig) && ishandle(control.cg.fig)
    %cgKeepParams();
end
saveParametersFile();


% --------------------------------------------------------------------
function channelCallsMenu_Callback(hObject, eventdata, handles)

% --------------------------------------------------------------------
function callDetectionMenu_Callback(hObject, eventdata, handles)

% --------------------------------------------------------------------
function featuresExtractionMenuItem_Callback(hObject, eventdata, handles)
mgGotoChannelCallsGui();

% --------------------------------------------------------------------
function callDetectionBasicMenuItem_Callback(hObject, eventdata, handles)
canceled = pdBasic(mgResolveFilesToWork());
mgRefreshChannelCallsDisplay();
if canceled
    msgbox('Aborted');
else
    msgbox('Finished calls detection');
end

% --------------------------------------------------------------------
function callDetectionPiecewiseMenuItem_Callback(hObject, eventdata, handles)
pwpdGUI();

% --------------------------------------------------------------------
function callDetectionManualMenuItem_Callback(hObject, eventdata, handles)
global control;
if control.mg.k == 0
    msgbox('No file on display');
else
    mgMpInit();
end

% --------------------------------------------------------------------
function channelCallsShowMenu_Callback(hObject, eventdata, handles)

% --------------------------------------------------------------------
function channelCallsShowNoMenuItem_Callback(hObject, eventdata, handles)
global c;
setParam('mainGUI:showCalls',c.no);
set(handles.channelCallsShowNoMenuItem, 'Checked', 'on');
set(handles.channelCallsShowYesMenuItem, 'Checked', 'off');
set(handles.channelCallsShowNumberMenuItem, 'Checked', 'off');
mgRefreshChannelCallsDisplay();


% --------------------------------------------------------------------
function channelCallsShowYesMenuItem_Callback(hObject, eventdata, handles)
global c;
setParam('mainGUI:showCalls',c.yes);
set(handles.channelCallsShowNoMenuItem, 'Checked', 'off');
set(handles.channelCallsShowYesMenuItem, 'Checked', 'on');
set(handles.channelCallsShowNumberMenuItem, 'Checked', 'off');
mgRefreshChannelCallsDisplay();


% --------------------------------------------------------------------
function channelCallsShowNumberMenuItem_Callback(hObject, eventdata, handles)
global c;
setParam('mainGUI:showCalls',c.numbered);
set(handles.channelCallsShowNoMenuItem, 'Checked', 'off');
set(handles.channelCallsShowYesMenuItem, 'Checked', 'off');
set(handles.channelCallsShowNumberMenuItem, 'Checked', 'on');
mgRefreshChannelCallsDisplay();


% --------------------------------------------------------------------
function channelCallsClearAllMenuItem_Callback(hObject, eventdata, handles)
removeFilesAllChannelCalls(mgResolveFilesToWork());
mgRefreshChannelCallsDisplay();


% --------------------------------------------------------------------
function settingsDecimateDisplayMenuItem_Callback(hObject, eventdata, handles)
set(handles.settingsDecimateDisplayNoMenuItem,'Checked','off');
set(handles.settingsDecimateDisplayMenuItem, 'Checked', 'on');
mgDisplayDecimation(true);

% --------------------------------------------------------------------
function settingsDecimateDisplayNoMenuItem_Callback(hObject, eventdata, handles)
set(handles.settingsDecimateDisplayNoMenuItem,'Checked','on');
set(handles.settingsDecimateDisplayMenuItem, 'Checked', 'off');
mgDisplayDecimation(false);


% --------------------------------------------------------------------
function pbSpectrogram_ClickedCallback(hObject, eventdata, handles)
global control;
zoom('off');
pan('off');
datacursormode('off');
mgTmInit(false);
mgSuInit(false);
mgSoInit(~control.mg.so.on);


% --------------------------------------------------------------------
function ioExportFileTsMenuItem_Callback(hObject, eventdata, handles)
K = mgResolveFilesToWork;
exportFileObject(K,true);
   

% --------------------------------------------------------------------
function ioExportFileNoTsMenuItem_Callback(hObject, eventdata, handles)
K = mgResolveFilesToWork;
exportFileObject(K,false);

% --------------------------------------------------------------------
function ioImportFileFileMenuItem_Callback(hObject, eventdata, handles)
importFileObjectFromFile();
mgRefreshFilesTable();

% --------------------------------------------------------------------
function ioImportFileVarManuItem_Callback(hObject, eventdata, handles)
importFileObjectFromVar();
mgRefreshFilesTable();

% --------------------------------------------------------------------
function ioExportChannelCallsMenuItem_Callback(hObject, eventdata, handles)
K = mgResolveFilesToWork();

if ~isempty(K)
    kca = cell(length(K),1);
    for i = 1:length(K)
        nJ = fileData(K(i),'Channels','Count');
        jca = cell(nJ,1);
        for j = 1:nJ
            jca{j} = exportChannelCalls(K(i),j,false);
        end
        kca{i} = jca;
    end
    assignin('base','channelCalls',kca);
end


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
global control;
if isempty(control)
    delete(hObject)
else
    mgKill();
end


% --------------------------------------------------------------------
function fcMenu_Callback(hObject, eventdata, handles)

% --------------------------------------------------------------------
function fcMicsMenuItem_Callback(hObject, eventdata, handles)
K = mgResolveFilesToWork();
if ~isempty(K)
    micsGUI(K);
end
    
% --------------------------------------------------------------------
function fcFpbMenuItem_Callback(hObject, eventdata, handles)
K = mgResolveFilesToWork();
if ~isempty(K)
    flightPathGUI(K(1));
end


% --------------------------------------------------------------------
function channelCallsGetMatrix_Callback(hObject, eventdata, handles)
mgGetChannelCallsMatrix();


% --------------------------------------------------------------------
function channelCallsGetRidges_Callback(hObject, eventdata, handles)
mgGetChannelCallsRidges();


% --------------------------------------------------------------------
function channelCallsGetTS_Callback(hObject, eventdata, handles)
mgGetChannelCallsTS();


% --------------------------------------------------------------------
function pbFilePrev_ClickedCallback(hObject, eventdata, handles)
n = appData('Files','Count');
if n == 0
    % do nothing
else
    k = appData('Files','Displayed');
    if k == 0
        % do nothing
    elseif k == 1
        msgbox('First file reached');
    else
        mgDisplayFile(k-1);
    end
end


% --------------------------------------------------------------------
function pbFileNext_ClickedCallback(hObject, eventdata, handles)
n = appData('Files','Count');
if n ==0 
    % do nothing
else
    k = appData('Files','Displayed');
    if k == n;
        msgbox('Last file reached');
    else
        mgDisplayFile(k+1);
    end
end


% --------------------------------------------------------------------
function filesChangePathName_Callback(hObject, eventdata, handles)
mgChangeFilePathName();

% --------------------------------------------------------------------
function filesChangePaths_Callback(hObject, eventdata, handles)
mgChangeFilesPath();


% --------------------------------------------------------------------
function fcGetCallsMenuItem_Callback(hObject, eventdata, handles)
mgGetFileCalls();


% --------------------------------------------------------------------
function pbSelAll_ClickedCallback(hObject, eventdata, handles)
for k = 1:appData('Files','Count')
    fileData(k,'Select',true);
end
mgRefreshFilesTable();

% --------------------------------------------------------------------
function pbSelNone_ClickedCallback(hObject, eventdata, handles)
for k = 1:appData('Files','Count')
    fileData(k,'Select',false);
end
mgRefreshFilesTable();


% --------------------------------------------------------------------
function pbDisplayFile_ClickedCallback(hObject, eventdata, handles)
K = mgResolveFilesToWork();
if ~isempty(K)
    mgDisplayFile(K(1));
end


% --------------------------------------------------------------------
function pbClearDisplay_ClickedCallback(hObject, eventdata, handles)
mgDisplayFile(0);


% --------------------------------------------------------------------
function toggleZoom_ClickedCallback(hObject, eventdata, handles)
mgSuInit(false);
mgSoInit(false);
mgTmInit(false);
pan('off');
if strcmp(get(hObject,'State'),'on')
    zoom('on');
else
    zoom('off');
end
%mpgKill();

% --------------------------------------------------------------------
function togglePan_ClickedCallback(hObject, eventdata, handles)
mgSuInit(false);
mgSoInit(false);
mgTmInit(false);
zoom('off');
if strcmp(get(hObject,'State'),'on')
    pan('on');
else
    pan('off');
end
%mpgKill();


% --------------------------------------------------------------------
function settingsGitUpdateMenuOtem_Callback(hObject, eventdata, handles)
gitAskSettings();

% --------------------------------------------------------------------
function toggleAxesLink_ClickedCallback(hObject, eventdata, handles)
global control;
global c;
set(handles.toggleAxesTight,'State','off')
set(handles.toggleAxesKeep,'State','off')
set(handles.toggleAxesLink,'State','on')
control.mg.axesMode = c.link;
mgLinkAxes( true )
mgRefreshAxes();


% --------------------------------------------------------------------
function toggleAxesKeep_ClickedCallback(hObject, eventdata, handles)
global control;
global c;
set(handles.toggleAxesTight,'State','off')
set(handles.toggleAxesLink,'State','off')
set(handles.toggleAxesKeep,'State','on')
control.mg.axesMode = c.keep;
mgLinkAxes( false )
mgRefreshAxes();


% --------------------------------------------------------------------
function toggleAxesTight_ClickedCallback(hObject, eventdata, handles)
global control;
global c;
set(handles.toggleAxesKeep,'State','off')
set(handles.toggleAxesLink,'State','off')
set(handles.toggleAxesTight,'State','on')
control.mg.axesMode = c.tight;
mgLinkAxes( false )
mgRefreshAxes();
