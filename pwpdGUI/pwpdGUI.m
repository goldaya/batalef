function varargout = pwpdGUI(varargin)
% PWPDGUI MATLAB code for pwpdGUI.fig
%      PWPDGUI, by itself, creates a new PWPDGUI or raises the existing
%      singleton*.
%
%      H = PWPDGUI returns the handle to a new PWPDGUI or the handle to
%      the existing singleton*.
%
%      PWPDGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PWPDGUI.M with the given input arguments.
%
%      PWPDGUI('Property','Value',...) creates a new PWPDGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before pwpdGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to pwpdGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help pwpdGUI

% Last Modified by GUIDE v2.5 28-Oct-2014 20:29:52

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @pwpdGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @pwpdGUI_OutputFcn, ...
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


% --- Executes just before pwpdGUI is made visible.
function pwpdGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to pwpdGUI (see VARARGIN)

% Choose default command line output for pwpdGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

global control;
if isempty(control.pwpdg.fig) || ~ishandle(control.pwpdg.fig)
    control.pwpdg.fig = hObject;
    pwpdgInit();
end


% --- Outputs from this function are returned to the command line.
function varargout = pwpdGUI_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;


% --- Executes on button press in pbManual.
function pbManual_Callback(hObject, eventdata, handles)
mgMpwpdInit();

function textWindow_Callback(hObject, eventdata, handles)
setParam('peaks:pwWindow',str2double(get(hObject, 'String')))

% --- Executes during object creation, after setting all properties.
function textWindow_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function textOverlap_Callback(hObject, eventdata, handles)
setParam('peaks:pwOverlap',str2double(get(hObject, 'String')))

% --- Executes during object creation, after setting all properties.
function textOverlap_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in pbShowIntervals.
function pbShowIntervals_Callback(hObject, eventdata, handles)
pwpdgShowIntervals(true);

% --- Executes on button press in pbDetectPeaks.
function pbDetectPeaks_Callback(hObject, eventdata, handles)
pwpdgDetectForFiles();


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
pwpdgKill();
