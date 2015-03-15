function varargout = spectrogramGUI(varargin)
% SPECTROGRAMGUI MATLAB code for spectrogramGUI.fig
%      SPECTROGRAMGUI, by itself, creates a new SPECTROGRAMGUI or raises the existing
%      singleton*.
%
%      H = SPECTROGRAMGUI returns the handle to a new SPECTROGRAMGUI or the handle to
%      the existing singleton*.
%
%      SPECTROGRAMGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SPECTROGRAMGUI.M with the given input arguments.
%
%      SPECTROGRAMGUI('Property','Value',...) creates a new SPECTROGRAMGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before spectrogramGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to spectrogramGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help spectrogramGUI

% Last Modified by GUIDE v2.5 10-Sep-2014 11:25:47

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @spectrogramGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @spectrogramGUI_OutputFcn, ...
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


% --- Executes just before spectrogramGUI is made visible.
function spectrogramGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to spectrogramGUI (see VARARGIN)

% Choose default command line output for spectrogramGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% keep figure
global control;
if isempty(control.sog.fig)
    control.sog.fig = hObject;
    sogInit();
end
control.sog.span = varargin{1};
sogPlot();
%{
% title
fileName = fileData(appData('Files','Displayed'),'Name');
title = strcat(['STFT: ',fileName]);
set(hObject, 'Name',title);
%}

% --- Outputs from this function are returned to the command line.
function varargout = spectrogramGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function textWindow_Callback(hObject, eventdata, handles)
% hObject    handle to textWindow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of textWindow as text
%        str2double(get(hObject,'String')) returns contents of textWindow as a double


% --- Executes during object creation, after setting all properties.
function textWindow_CreateFcn(hObject, eventdata, handles)
% hObject    handle to textWindow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function textNfft_Callback(hObject, eventdata, handles)
% hObject    handle to textNfft (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of textNfft as text
%        str2double(get(hObject,'String')) returns contents of textNfft as a double


% --- Executes during object creation, after setting all properties.
function textNfft_CreateFcn(hObject, eventdata, handles)
% hObject    handle to textNfft (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function textOverlap_Callback(hObject, eventdata, handles)
% hObject    handle to textOverlap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of textOverlap as text
%        str2double(get(hObject,'String')) returns contents of textOverlap as a double


% --- Executes during object creation, after setting all properties.
function textOverlap_CreateFcn(hObject, eventdata, handles)
% hObject    handle to textOverlap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pbReplot.
function pbReplot_Callback(hObject, eventdata, handles)
sogPlot();

% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
sogKill();