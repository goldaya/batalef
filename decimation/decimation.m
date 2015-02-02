function varargout = decimation(varargin)
% DECIMATION MATLAB code for decimation.fig
%      DECIMATION, by itself, creates a new DECIMATION or raises the existing
%      singleton*.
%
%      H = DECIMATION returns the handle to a new DECIMATION or the handle to
%      the existing singleton*.
%
%      DECIMATION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DECIMATION.M with the given input arguments.
%
%      DECIMATION('Property','Value',...) creates a new DECIMATION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before decimation_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to decimation_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help decimation

% Last Modified by GUIDE v2.5 04-Dec-2013 10:25:49

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @decimation_OpeningFcn, ...
                   'gui_OutputFcn',  @decimation_OutputFcn, ...
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


% --- Executes just before decimation is made visible.
function decimation_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to decimation (see VARARGIN)

% Choose default command line output for decimation
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% init Values
global p q N;
p = 0;
q = 0;
N = 0;

% show default values
set(handles.textbox_N,'String', getParam('decimation:N'));
set(handles.textbox_p,'String', getParam('decimation:p'));
set(handles.textbox_q,'String', getParam('decimation:q'));

% UIWAIT makes decimation wait for user response (see UIRESUME)
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = decimation_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% keep values
setParam('decimation:p', str2double(get(handles.textbox_p, 'String')));
setParam('decimation:q', str2double(get(handles.textbox_q, 'String')));
setParam('decimation:N', str2double(get(handles.textbox_N, 'String')));
% output
global p q N;
ret.p = p;
ret.q = q;
ret.N = N;
varargout{1} = ret;

% delete gui from screen
delete(hObject);


% --- Executes on button press in okButton.
function okButton_Callback(hObject, eventdata, handles)
% hObject    handle to okButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global p q N;
    rb_n = handles.radiobutton_n;
    v_n = get(rb_n, 'Value');
    rb_N = handles.radiobutton_N;
    v_N = get(rb_N, 'Value');
    if v_n > 0
        p = str2num(get(handles.textbox_p, 'String'));
        q = str2num(get(handles.textbox_q, 'String'));
        N = 0;
    elseif v_N > 0
        N = str2num(get(handles.textbox_N, 'String'));
        p = 0;
        q = 0;
    else
        N = 0;
        p = 0;
        q = 0;
    end

% EXIT
%when waiting stop waiting, otherwise, just delete the gui object
if isequal(get(gcf, 'waitstatus'),'waiting')
    uiresume(gcf);
else
    delete(gcf);
end
   
    
% --- Executes on button press in radiobutton_N.
function radiobutton_N_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_N (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_N



function textbox_N_Callback(hObject, eventdata, handles)
% hObject    handle to textbox_p (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of textbox_p as text
%        str2double(get(hObject,'String')) returns contents of textbox_p as a double


% --- Executes during object creation, after setting all properties.
function textbox_N_CreateFcn(hObject, eventdata, handles)
% hObject    handle to textbox_p (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in radiobutton_n.
function radiobutton_n_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_n (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_n



function textbox_p_Callback(hObject, eventdata, handles)
% hObject    handle to textbox_p (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of textbox_p as text
%        str2double(get(hObject,'String')) returns contents of textbox_p as a double


% --- Executes during object creation, after setting all properties.
function textbox_p_CreateFcn(hObject, eventdata, handles)
% hObject    handle to textbox_p (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function textbox_q_Callback(hObject, eventdata, handles)
% hObject    handle to textbox_q (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of textbox_q as text
%        str2double(get(hObject,'String')) returns contents of textbox_q as a double


% --- Executes during object creation, after setting all properties.
function textbox_q_CreateFcn(hObject, eventdata, handles)
% hObject    handle to textbox_q (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
