'function varargout = fileCallsGUI(varargin)
% FILECALLSGUI MATLAB code for fileCallsGUI.fig
%      FILECALLSGUI, by itself, creates a new FILECALLSGUI or raises the existing
%      singleton*.
%
%      H = FILECALLSGUI returns the handle to a new FILECALLSGUI or the handle to
%      the existing singleton*.
%
%      FILECALLSGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FILECALLSGUI.M with the given input arguments.
%
%      FILECALLSGUI('Property','Value',...) creates a new FILECALLSGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before fileCallsGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to fileCallsGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help fileCallsGUI

% Last Modified by GUIDE v2.5 01-Sep-2015 13:38:46

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @fileCallsGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @fileCallsGUI_OutputFcn, ...
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


% --- Executes just before fileCallsGUI is made visible.
function fileCallsGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to fileCallsGUI (see VARARGIN)

% Choose default command line output for fileCallsGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes fileCallsGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);
k = varargin{1};
fcgStart(hObject,k);

% --- Outputs from this function are returned to the command line.
function varargout = fileCallsGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function textIdx_Callback(hObject, eventdata, handles)
A = str2num(get(hObject,'String'));
if isempty(A)
    msgbox('File calls selection invalid');
else
    fcgRefreshBeamPanel()
end
   

% --- Executes during object creation, after setting all properties.
function textIdx_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in ddBaseChannel.
function ddBaseChannel_Callback(hObject, eventdata, handles)
fcgPopulateBaseCallsList();
fcgPopulatePossibleMatches();

% --- Executes during object creation, after setting all properties.
function ddBaseChannel_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in ddBaseCall.
function ddBaseCall_Callback(hObject, eventdata, handles)
fcgPopulatePossibleMatches();

% --- Executes during object creation, after setting all properties.
function ddBaseCall_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function textErrTol_Callback(hObject, eventdata, handles)
setParam('fileCalls:matching:triangleMaxError',str2double(get(hObject,'String'))/100+1);

% --- Executes during object creation, after setting all properties.
function textErrTol_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject, 'String', num2str((getParam('fileCalls:matching:triangleMaxError')-1)*100));


% --- Executes on button press in pbFindMatches.
function pbFindMatches_Callback(hObject, eventdata, handles)
fcgPopulatePossibleMatches();

% --- Executes on selection change in ddSeqs.
function ddSeqs_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function ddSeqs_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pbAccept.
function pbAccept_Callback(hObject, eventdata, handles)
fcgAcceptCall();


% --- Executes on button press in pbAcceptAll.
function pbAcceptAll_Callback(hObject, eventdata, handles)
fcgAcceptAll();


% --- Executes on button press in pbNextBaseCall.
function pbNextBaseCall_Callback(hObject, eventdata, handles)
fcgNextBaseCall();


% --- Executes on button press in pbPrev.
function pbPrev_Callback(hObject, eventdata, handles)
[k,a] = fcgGetCurrent();
N = fileData(k,'Calls','Count','NoValidation',true);
if a <= 1
    a = 1;
elseif a > N
    a = N;
else
	a = a - 1;
end
set(handles.textIdx, 'String', num2str(a));
fcgRefreshBeamPanel();



% --- Executes on button press in pbNext.
function pbNext_Callback(hObject, eventdata, handles)
[k,a] = fcgGetCurrent();
N = fileData(k,'Calls','Count','NoValidation',true);
if a >= N
    a = N;
else
    a = a+1;
end
set(handles.textIdx, 'String', num2str(a));
fcgRefreshBeamPanel();


% --- Executes on button press in pbSelectAll.
function pbSelectAll_Callback(hObject, eventdata, handles)
k = fcgGetCurrent();
N = fileData(k,'Calls','Count','NoValidation',true);
set(handles.textIdx,'String',strcat('1:',num2str(N)));


% --- Executes on button press in pbX.
function pbX_Callback(hObject, eventdata, handles)
    k = fcgGetCurrent();
    A = str2num(get(handles.textIdx,'String')); %#ok<ST2NM>
    deleteFileCall(k,A);
    set(handles.textIdx,'String','0');
    fcgRefresh();


% --- Executes on button press in pbCompRaw.
function pbCompRaw_Callback(hObject, eventdata, handles)
fcgPlotRaw();


% --------------------------------------------------------------------
function dmAirMenuItem_Callback(hObject, eventdata, handles)
airAbsorptionDialog();

% --------------------------------------------------------------------
function beamComputeMenuItem_Callback(hObject, eventdata, handles)

% --------------------------------------------------------------------
function beamClearMenuItem_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function locComputeMenuItem_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function locFileMenuItem_Callback(hObject, eventdata, handles)
D = dialogLoadFile();
fpgReplaceLocations(D);

% --------------------------------------------------------------------
function locVarMenuItem_Callback(hObject, eventdata, handles)
D = dialogLoadVar();
fpgReplaceLocations(D);


% --------------------------------------------------------------------
function micAdminMenuItem_Callback(hObject, eventdata, handles)
k = fcgGetCurrent();
micsGUI(k);


% --------------------------------------------------------------------
function dmBeamSurf_Callback(hObject, eventdata, handles)
% hObject    handle to dmBeamSurf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function dmBeamGenetic_Callback(hObject, eventdata, handles)
% hObject    handle to dmBeamGenetic (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function dmLocMlat_Callback(hObject, eventdata, handles)
% hObject    handle to dmLocMlat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function dmLocArray_Callback(hObject, eventdata, handles)
% hObject    handle to dmLocArray (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
