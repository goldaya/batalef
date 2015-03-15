function varargout = micsGUI(varargin)
% MICSGUI MATLAB code for micsGUI.fig
%      MICSGUI, by itself, creates a new MICSGUI or raises the existing
%      singleton*.
%
%      H = MICSGUI returns the handle to a new MICSGUI or the handle to
%      the existing singleton*.
%
%      MICSGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MICSGUI.M with the given input arguments.
%
%      MICSGUI('Property','Value',...) creates a new MICSGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before micsGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to micsGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help micsGUI

% Last Modified by GUIDE v2.5 26-Feb-2015 01:03:16

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @micsGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @micsGUI_OutputFcn, ...
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


% --- Executes just before micsGUI is made visible.
function micsGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to micsGUI (see VARARGIN)

% Choose default command line output for micsGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

global control;

% init framework
if isempty(control.mcg.fig) || ~ishandle(control.mcg.fig)
    control.mcg.fig = hObject;
    mcgInit(control.mcg.fig);
end

% init files to work on
K = varargin{1};
control.mcg.K = K;


% show current positions

M = fileData(K(1),'Mics','Matrix');
C = num2cell(M);
U = C(:,1:2);
U = cell2mat(U);
U = logical(U);
U = num2cell(U);
C(:,1:2) = U;
[~,micsTableObj] = mcgGetHandles('tableMics');
set(micsTableObj,'Data',C);

% keep number of channels
control.mcg.n = size(M,1);

% --- Outputs from this function are returned to the command line.
function varargout = micsGUI_OutputFcn(hObject, eventdata, handles) 
global control;
K = control.mcg.K;
a = checkMicsUnity(K);
if a < 0
    errordlg(...
        {'You have selected multiple files with different number of channels.',...
        'It is not possible to edit their mic positions together.'});
    mcgKill();
    return;
elseif a == 0
    warndlg(...
        {'You have selected multiple files which currently do not have the same mics admin data.', ...
        'When saving the mic admin table you will save for all selected files !'});
end

% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
mcgKill();



% --- Executes on button press in pbSave.
function pbSave_Callback(hObject, eventdata, handles)
rc = mcgSave();
if rc > 0
    fpgKill();
end



% --- Executes on button press in pbSaveClose.
function pbSaveClose_Callback(hObject, eventdata, handles)
dontSave = mcgSave();
if dontSave;
    fpgKill();
else
    mcgKill();
end


% --------------------------------------------------------------------
function setLocalizationParamsMenuItem_Callback(hObject, eventdata, handles)
mcgParamsDialog();


% --------------------------------------------------------------------
function positionsLoadFileMenuItem_Callback(hObject, eventdata, handles)
global control;
[filename, path] = uigetfile({'*.mat','Matlab File (.mat)';...
                                    '*.*', 'All files'});
if ~ischar(filename) || ~ischar(path)
    return;
end
M = importdata( strcat( path, filename ) );
if size(M,1)~=control.mcg.n
    errordlg('Mismatch in number of channels');
    return;
end
mcgChangePositions(M);

% --------------------------------------------------------------------
function positionsLoadVarMenuItem_Callback(hObject, eventdata, handles)
global control;
varName = inputdlg('Variable Name');

try
    M = evalin('base',varName{1});
catch err
    if strcmp(err.identifier, 'MATLAB:UndefinedFunction')
        msgbox('No such variable in base workspace');
        return;
    else
        throw(err);
    end
end
    
if size(M,1)~=control.mcg.n
    errordlg('Mismatch in number of channels');
    return;
end
mcgChangePositions(M);


% --------------------------------------------------------------------
function calibLoadFileMenuItem_Callback(hObject, eventdata, handles)
[filename, path] = uigetfile({'*.mat','Matlab File (.mat)';...
                                    '*.*', 'All files'});
if ~ischar(filename) || ~ischar(path)
    return;
end
G = importdata( strcat( path, filename ) );
mcgChangeGains(G);


% --------------------------------------------------------------------
function calibLoadVarMenuItem_Callback(hObject, eventdata, handles)
varName = inputdlg('Variable Name');
try
    G = evalin('base',varName{1});
catch err
    if strcmp(err.identifier, 'MATLAB:UndefinedFunction')
        msgbox('No such variable in base workspace');
        return;
    else
        throw(err);
    end
end
mcgChangeGains(G);


% --------------------------------------------------------------------
function directLoadFileMenuItem_Callback(hObject, eventdata, handles)
[filename, path] = uigetfile({'*.mat','Matlab File (.mat)';...
                                    '*.*', 'All files'});
if ~ischar(filename) || ~ischar(path)
    return;
end
D = importdata( strcat( path, filename ) );
mcgChangeDirectivity(D);


% --------------------------------------------------------------------
function dirctLoadVarMenuItem_Callback(hObject, eventdata, handles)
varName = inputdlg('Variable Name');
try
    D = evalin('base',varName{1});
catch err
    if strcmp(err.identifier, 'MATLAB:UndefinedFunction')
        msgbox('No such variable in base workspace');
        return;
    else
        throw(err);
    end
end
mcgChangeDirectivity(D);


% --- Executes on button press in cbManageDirectivity.
function cbManageDirectivity_Callback(hObject, eventdata, handles)
% hObject    handle to cbManageDirectivity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cbManageDirectivity



function textZeroVector_Callback(hObject, eventdata, handles)
% hObject    handle to textZeroVector (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of textZeroVector as text
%        str2double(get(hObject,'String')) returns contents of textZeroVector as a double


% --- Executes during object creation, after setting all properties.
function textZeroVector_CreateFcn(hObject, eventdata, handles)
% hObject    handle to textZeroVector (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function textMinN_Callback(hObject, eventdata, handles)
% hObject    handle to textMinN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of textMinN as text
%        str2double(get(hObject,'String')) returns contents of textMinN as a double


% --- Executes during object creation, after setting all properties.
function textMinN_CreateFcn(hObject, eventdata, handles)
% hObject    handle to textMinN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function textMinDepth_Callback(hObject, eventdata, handles)
% hObject    handle to textMinDepth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of textMinDepth as text
%        str2double(get(hObject,'String')) returns contents of textMinDepth as a double


% --- Executes during object creation, after setting all properties.
function textMinDepth_CreateFcn(hObject, eventdata, handles)
% hObject    handle to textMinDepth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
