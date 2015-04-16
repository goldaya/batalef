function varargout = callsGUI(varargin)
% CALLSGUI MATLAB code for callsGUI.fig
%      CALLSGUI, by itself, creates a new CALLSGUI or raises the existing
%      singleton*.
%
%      H = CALLSGUI returns the handle to a new CALLSGUI or the handle to
%      the existing singleton*.
%
%      CALLSGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CALLSGUI.M with the given input arguments.
%
%      CALLSGUI('Property','Value',...) creates a new CALLSGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before callsGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to callsGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help callsGUI

% Last Modified by GUIDE v2.5 06-Apr-2015 20:04:10

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @callsGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @callsGUI_OutputFcn, ...
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




% --- Executes just before callsGUI is made visible.
function callsGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to callsGUI (see VARARGIN)

% Choose default command line output for callsGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);


% keep figure code
global control;
if isempty(control.cg.fig) || ~ishandle(control.cg.fig)
    control.cg.fig = hObject;
    cgInit();
end

% indexes
defProcType = 'features';
switch nargin
    case 3 % 3 regular + 0 varargin
        control.cg.k = 1;
        control.cg.j = 1;
        control.cg.s = 1;
        control.cg.t = defProcType;    
    case 4 % 1 varagin
        control.cg.k = varargin{1};
        control.cg.j = 1;
        control.cg.s = 1;
        control.cg.t = defProcType;    
    case 5
        control.cg.k = varargin{1};
        control.cg.j = varargin{2};
        control.cg.s = 1;
        control.cg.t = defProcType;    
    case 6
        control.cg.k = varargin{1};
        control.cg.j = varargin{2};
        control.cg.s = varargin{3};
        control.cg.t = defProcType;
    case 7
        control.cg.k = varargin{1};
        control.cg.j = varargin{2};
        control.cg.s = varargin{3};
        control.cg.t = varargin{4};
    otherwise
end
cgShowCall();



% --- Outputs from this function are returned to the command line.
function varargout = callsGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
delete(hObject);

% --- Executes during object deletion, before destroying properties.
function figure1_DeleteFcn(hObject, eventdata, handles)
cgKill();

function pbChannelDown_Callback(hObject, eventdata, handles)
[c(1),c(2),c(3)] = cgGetCurrent();
cgGotoCall(c-[0,1,0]);

function textChannelIndex_Callback(hObject, eventdata, handles)
[c(1),c(2),c(3)] = cgGetCurrent();
c(2) = str2double(get(hObject, 'String'));
cgGotoCall(c);

function textChannelIndex_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function textChannelsTotal_CreateFcn(hObject, eventdata, handles)


function pbChannelUp_Callback(hObject, eventdata, handles)
[c(1),c(2),c(3)] = cgGetCurrent();
cgGotoCall(c+[0,1,0]);

function pbFileDown_Callback(hObject, eventdata, handles)
[c(1),c(2),c(3)] = cgGetCurrent();
cgGotoCall(c-[1,0,0]);

function textFileIndex_Callback(hObject, eventdata, handles)
[c(1),c(2),c(3)] = cgGetCurrent();
c(1) = str2double(get(hObject, 'String'));
cgGotoCall(c);

function textFileIndex_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function pbFileUp_Callback(hObject, eventdata, handles)
[c(1),c(2),c(3)] = cgGetCurrent();
cgGotoCall(c+[1,0,0]);

function pbCallDown_Callback(hObject, eventdata, handles)
[c(1),c(2),c(3)] = cgGetCurrent();
cgGotoCall(c-[0,0,1]);


function textCallIndex_Callback(hObject, eventdata, handles)
[c(1),c(2),c(3)] = cgGetCurrent();
c(3) = str2double(get(hObject, 'String'));
cgGotoCall(c);

function textCallIndex_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function pbCallUp_Callback(hObject, eventdata, handles)
[k,j,s] = cgGetCurrent();
s = s + 1;
cgGotoCall(k,j,s);

function textCallWindow_Callback(hObject, eventdata, handles)
cgRefresh()

function textCallWindow_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function textStartDiff_Callback(hObject, eventdata, handles)
dB = str2double(get(hObject, 'String'));
s = 1-10^(dB/10);
set(handles.sliderStartDiff, 'Value', s);
cgRefresh()


function textStartDiff_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function sliderStartDiff_Callback(hObject, eventdata, handles)
dB = 10*log10(1-get(hObject,'Value'));
set(handles.textStartDiff,'String',num2str(dB));
cgRefresh()


function sliderStartDiff_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function textEndDiff_Callback(hObject, eventdata, handles)
dB = str2double(get(hObject, 'String'));
s = 1-10^(dB/10);
set(handles.sliderEndDiff, 'Value', s);
cgRefresh()

function textEndDiff_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function sliderEndDiff_Callback(hObject, eventdata, handles)
dB = 10*log10(1-get(hObject,'Value'));
set(handles.textEndDiff,'String',num2str(dB));
cgRefresh()


function sliderEndDiff_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function textGap_Callback(hObject, eventdata, handles)
gap = str2double(get(hObject, 'String'));
mGap = getParam('callsGUI:maxGap');
if gap > mGap
    gap = mGap;
    mGapStr = num2str(mGap);
    msgbox({strcat(['Maximal gap value is ',mGapStr,'.']),'This can be changed through the parameters file'});
    set(hObject, 'String', mGapStr);
end
% setParam('callsGUI:gap', gap);
set(handles.sliderGap, 'Value', str2double(get(hObject, 'String')));
cgRefresh()


function textGap_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function sliderGap_Callback(hObject, eventdata, handles)
gap = get(hObject, 'Value');
setParam('callsGUI:gap', gap);
set(handles.textGap, 'String', num2str(gap));
cgRefresh()


function sliderGap_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


function textStartFreq_Callback(hObject, eventdata, handles)


function textStartFreq_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function textEndFreq_Callback(hObject, eventdata, handles)


function textEndFreq_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function textPeakFreq_Callback(hObject, eventdata, handles)


function textPeakFreq_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function textStartTime_Callback(hObject, eventdata, handles)


function textStartTime_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function textEndTime_Callback(hObject, eventdata, handles)


function textEndTime_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function textDuration_Callback(hObject, eventdata, handles)


function textDuration_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function textStartPoint_Callback(hObject, eventdata, handles)


function textStartPoint_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function textEndPoint_Callback(hObject, eventdata, handles)


function textEndPoint_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function textDurationPoint_Callback(hObject, eventdata, handles)


function textDurationPoint_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function textPeakTime_Callback(hObject, eventdata, handles)


function textPeakTime_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function textPeakPoint_Callback(hObject, eventdata, handles)


function textPeakPoint_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function pbSave_Callback(hObject, eventdata, handles)
global control;
control.cg.call.save();

function pbSaveNext_Callback(hObject, eventdata, handles)
pbSave_Callback(hObject, eventdata, handles)
pbCallUp_Callback(hObject, eventdata, handles)

function pbDeleteCall_Callback(hObject, eventdata, handles)



function uipanel4_SelectionChangeFcn(hObject, eventdata, handles)
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
cgRefresh()


% --------------------------------------------------------------------
function dfaCallsMenuItem_Callback(hObject, eventdata, handles)
[k,j] = cgGetCurrent();
K(1) = k;
J(1) = j;
cgDoForAll(K,J);

% --------------------------------------------------------------------
function dfaChannelsMenuItem_Callback(hObject, eventdata, handles)
K(1) = cgGetCurrent;
cgDoForAll(K,[]);

% --------------------------------------------------------------------
function dfaSelectedFilesMenuItem_Callback(hObject, eventdata, handles)
K = mgResolveFilesToWork();
cgDoForAll(K,[]);

% --------------------------------------------------------------------
function dfaAllFilesMenuItem_Callback(hObject, eventdata, handles)
nK = appData('Files','Count');
K = 1:nK;
cgDoForAll(K,[]);



function textDetectionTime_Callback(hObject, eventdata, handles)
% hObject    handle to textDetectionTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of textDetectionTime as text
%        str2double(get(hObject,'String')) returns contents of textDetectionTime as a double


% --- Executes during object creation, after setting all properties.
function textDetectionTime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to textDetectionTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function textDetectionPoint_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function textDetectionPoint_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pbRedraw.
function pbRedraw_Callback(hObject, eventdata, handles)
cgRefresh();



function textDeltaTime_Callback(hObject, eventdata, handles)
% hObject    handle to textDeltaTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of textDeltaTime as text
%        str2double(get(hObject,'String')) returns contents of textDeltaTime as a double


% --- Executes during object creation, after setting all properties.
function textDeltaTime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to textDeltaTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function textDeltaPoints_CreateFcn(hObject, eventdata, handles)
% hObject    handle to textDeltaPoints (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function textBandwidthRMS_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function textBandwidthRMS_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --------------------------------------------------------------------
function paramsKeepMenuItem_Callback(hObject, eventdata, handles)
cgKeepParams();

% --------------------------------------------------------------------
function paramsRestoreMenuItem_Callback(hObject, eventdata, handles)
cgRestoreParams();


% --- Executes on button press in pbManual.
function pbManual_Callback(hObject, eventdata, handles)
global control;
if isfield(control.cg,'spectrogramSurf') && ishandle(control.cg.spectrogramSurf)
    set(control.cg.spectrogramSurf,'ButtonDownFcn',@cgManualCallRealization);
end


% --- Executes on selection change in ddType.
function ddType_Callback(hObject, eventdata, handles)
global control;
D = get(hObject,'UserData');
v = get(hObject,'Value' );
control.cg.t = D(v);

% --- Executes during object creation, after setting all properties.
function ddType_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
global control;
D{1} = 'features';
D{2} = 'forLocalization';
D{3} = 'forBeam';
set(hObject,'UserData',D);
v = find(strcmp(control.cg.t,D));
if isempty(v)
    v = 1;
end
set(hObject,'Value',v);