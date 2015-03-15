function varargout = manualPeaksGUI(varargin)
% MANUALPEAKSGUI MATLAB code for manualPeaksGUI.fig
%      MANUALPEAKSGUI, by itself, creates a new MANUALPEAKSGUI or raises the existing
%      singleton*.
%
%      H = MANUALPEAKSGUI returns the handle to a new MANUALPEAKSGUI or the handle to
%      the existing singleton*.
%
%      MANUALPEAKSGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MANUALPEAKSGUI.M with the given input arguments.
%
%      MANUALPEAKSGUI('Property','Value',...) creates a new MANUALPEAKSGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before manualPeaksGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to manualPeaksGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help manualPeaksGUI

% Last Modified by GUIDE v2.5 12-Jan-2015 08:39:19

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @manualPeaksGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @manualPeaksGUI_OutputFcn, ...
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


% --- Executes just before manualPeaksGUI is made visible.
function manualPeaksGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to manualPeaksGUI (see VARARGIN)

% Choose default command line output for manualPeaksGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

global control;
if isempty(control.mpg.fig)
    control.mpg.fig = hObject;
    mpgInit();
end
control.mpg.locked = false;


% --- Outputs from this function are returned to the command line.
function varargout = manualPeaksGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pbPlus.
function pbPlus_Callback(hObject, eventdata, handles)
mpgZoomIncrease( 0.2 );


% --- Executes on button press in pbMinus.
function pbMinus_Callback(hObject, eventdata, handles)
mpgZoomIncrease( 5 );


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
mpgKill();


% --- Executes on button press in pbMaximum.
function pbMaximum_Callback(hObject, eventdata, handles)
mpgLocalMaximum();

% --- Executes on button press in pbManual.
function pbManual_Callback(hObject, eventdata, handles)
mpgManualMark();

% --- Executes on button press in pbDelete.
function pbDelete_Callback(hObject, eventdata, handles)
mpgRemovePeaks(  )
