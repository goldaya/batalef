function varargout = beamManipulationGUI(varargin)
% BEAMMANIPULATIONGUI MATLAB code for beamManipulationGUI.fig
%      BEAMMANIPULATIONGUI, by itself, creates a new BEAMMANIPULATIONGUI or raises the existing
%      singleton*.
%
%      H = BEAMMANIPULATIONGUI returns the handle to a new BEAMMANIPULATIONGUI or the handle to
%      the existing singleton*.
%
%      BEAMMANIPULATIONGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BEAMMANIPULATIONGUI.M with the given input arguments.
%
%      BEAMMANIPULATIONGUI('Property','Value',...) creates a new BEAMMANIPULATIONGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before beamManipulationGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to beamManipulationGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help beamManipulationGUI

% Last Modified by GUIDE v2.5 25-May-2015 00:05:52

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @beamManipulationGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @beamManipulationGUI_OutputFcn, ...
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


% --- Executes just before beamManipulationGUI is made visible.
function beamManipulationGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to beamManipulationGUI (see VARARGIN)

% Choose default command line output for beamManipulationGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

global control;
control.bmg.fig = hObject;

% if uitable does not exist, create it
if ~isfield(handles, 'uitabBeamData')
    bmgCreateTable(hObject);
end

% fill data
control.bmg.k = varargin{1};
control.bmg.a = varargin{2};
bmgReadData();

% UIWAIT makes beamManipulationGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);




% --- Outputs from this function are returned to the command line.
function varargout = beamManipulationGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function pbSaveCompute_ClickedCallback(hObject, eventdata, handles)
bmgSave();


% --------------------------------------------------------------------
function pbUndo_ClickedCallback(hObject, eventdata, handles)
bmgReadData();
