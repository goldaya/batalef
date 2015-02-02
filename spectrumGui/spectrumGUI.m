function varargout = spectrumGUI(varargin)
% SPECTRUMGUI MATLAB code for spectrumGUI.fig
%      SPECTRUMGUI, by itself, creates a new SPECTRUMGUI or raises the existing
%      singleton*.
%
%      H = SPECTRUMGUI returns the handle to a new SPECTRUMGUI or the handle to
%      the existing singleton*.
%
%      SPECTRUMGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SPECTRUMGUI.M with the given input arguments.
%
%      SPECTRUMGUI('Property','Value',...) creates a new SPECTRUMGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before spectrumGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to spectrumGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help spectrumGUI

% Last Modified by GUIDE v2.5 09-Sep-2014 19:53:19

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @spectrumGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @spectrumGUI_OutputFcn, ...
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


% --- Executes just before spectrumGUI is made visible.
function spectrumGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to spectrumGUI (see VARARGIN)

% Choose default command line output for spectrumGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

global control;
if isempty(control.sug.fig) || ~ishandle(control.sug.fig)
    control.sug.fig = hObject;
    sugInit();
end
sugPlot(varargin{1});
%{
fileName = fileData(appData('Files','Displayed'),'Name');
title = strcat(['Spectrum: ',fileName]);
set(hObject,'Name',title);
%}

% --- Outputs from this function are returned to the command line.
function varargout = spectrumGUI_OutputFcn(hObject, eventdata, handles) 
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


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
sugKill();
