function varargout = flightPathGUI(varargin)
% FLIGHTPATHGUI MATLAB code for flightPathGUI.fig
%      FLIGHTPATHGUI, by itself, creates a new FLIGHTPATHGUI or raises the existing
%      singleton*.
%
%      H = FLIGHTPATHGUI returns the handle to a new FLIGHTPATHGUI or the handle to
%      the existing singleton*.
%
%      FLIGHTPATHGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FLIGHTPATHGUI.M with the given input arguments.
%
%      FLIGHTPATHGUI('Property','Value',...) creates a new FLIGHTPATHGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before flightPathGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to flightPathGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help flightPathGUI

% Last Modified by GUIDE v2.5 07-May-2015 23:58:53

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @flightPathGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @flightPathGUI_OutputFcn, ...
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


% --- Executes just before flightPathGUI is made visible.
function flightPathGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to flightPathGUI (see VARARGIN)

% Choose default command line output for flightPathGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% keep figure object
global control;
if isempty(control.fpg.fig) || ~ishandle(control.fpg.fig)
    control.fpg.fig = hObject;
end

% file indexe
if isempty(varargin)
    control.fpg.k = 1;
else
    control.fpg.k = varargin{1};
end

% init
fpgInit(control.fpg.k);



% --- Outputs from this function are returned to the command line.
function varargout = flightPathGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in ddBaseChannel.
function ddBaseChannel_Callback(hObject, eventdata, handles)
fpgSetBaseChannel(get(hObject, 'Value'));

% --- Executes during object creation, after setting all properties.
function ddBaseChannel_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in ddBaseCall.
function ddBaseCall_Callback(hObject, eventdata, handles)
fpgSetBaseCall(get(hObject, 'Value'));

% --- Executes during object creation, after setting all properties.
function ddBaseCall_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in ddSeqs.
function ddSeqs_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function ddSeqs_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pbAccept.
function pbAccept_Callback(hObject, eventdata, handles)
fpgAcceptCall();

% --- Executes on button press in pbBaseCallNext.
function pbBaseCallNext_Callback(hObject, eventdata, handles)
fpgNextBaseCall();

% --- Executes on button press in pbRemove.
function pbRemove_Callback(hObject, eventdata, handles)
fpgDeleteFileCall();

% --------------------------------------------------------------------


% --- Executes on button press in pbMics.
function pbMics_Callback(hObject, eventdata, handles)



% --- Executes when selected cell(s) is changed in uitabFileCalls.
function uitabFileCalls_CellSelectionCallback(hObject, eventdata, handles)
set(hObject, 'UserData', eventdata.Indices);


% --- Executes when entered data in editable cell(s) in uitabFileCalls.
function uitabFileCalls_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to uitabFileCalls (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)
set(hObject,'UserData',eventdata.Indices(1));
if ~strcmp(eventdata.PreviousData,eventdata.NewData)
    k = fpgGetCurrent( );
    a = eventdata.Indices(1); % file call
    switch eventdata.Indices(2)
        case 1
            changeFileCall(k,a,'Time',str2double(eventdata.EditData));
        case 2
            changeFileCall(k,a,'Location',str2num(eventdata.EditData));
    end
    fpgRefresh3DRoute();
end



% --------------------------------------------------------------------
function airMenuItem_Callback(hObject, eventdata, handles)
fpgAirDialog();


% --- Executes on button press in pbView.
function pbView_Callback(hObject, eventdata, handles)
% hObject    handle to pbView (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function uitabFileCalls_ButtonDownFcn(hObject, eventdata, handles)
global control;
a = get(hObject,'UserData');
if a(1) > 0
    control.fpg.a = a;
    fpgRefreshBeam();
end


% --------------------------------------------------------------------
function beamsComputeAllMenuItem_Callback(hObject, eventdata, handles)
k = fpgGetCurrent();
n = fileData(k,'Calls','Count');
for i = 1:n
    calculateBeam(k,i);
end
msgbox('Finished beam computation')

% --------------------------------------------------------------------
function beamsComputeSingleMenuItem_Callback(hObject, eventdata, handles)
[k,~,~,a] = fpgGetCurrent();
if a > 0
    calculateBeam(k,a);
end
msgbox('Finished beam computation')


% --- Executes on button press in pbRefreshBase.
function pbRefreshBase_Callback(hObject, eventdata, handles)
fpgRefreshBaseCallsList();
fpgRefreshSeqList();


% --------------------------------------------------------------------
function beamParamsMenuItem_Callback(hObject, eventdata, handles)
fpgBeamParamsDialog();


% --------------------------------------------------------------------
function beamShowRawMenuItem_Callback(hObject, eventdata, handles)
fpgBeamShowRaw();


% --------------------------------------------------------------------
function relocateVarManuItem_Callback(hObject, eventdata, handles)
D = dialogLoadVar();
fpgReplaceLocations(D);

% --------------------------------------------------------------------
function relocateFileMenuItem_Callback(hObject, eventdata, handles)
D = dialogLoadFile();
fpgReplaceLocations(D);



function textError_Callback(hObject, eventdata, handles)
setParam('fileCalls:matching:triangleMaxError',1+(str2double(get(hObject,'String')))/100);

% --- Executes during object creation, after setting all properties.
function textError_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String',num2str((getParam('fileCalls:matching:triangleMaxError')-1)*100));


% --------------------------------------------------------------------
function micAdminMenuItem_Callback(hObject, eventdata, handles)
k = fpgGetCurrent();
micsGUI(k);


% --- Executes on button press in pbAcceptAll.
function pbAcceptAll_Callback(hObject, eventdata, handles)
fpgAcceptAll();
msgbox('Accepted all calls');
fpgRefresh();



function textIdx_Callback(hObject, eventdata, handles)



% --- Executes during object creation, after setting all properties.
function textIdx_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function pbPrev_Callback(hObject, eventdata, handles)
[k,a] = fpgGetCurrent();
N = fileData(k,'Calls','Count','NoValidation',true);
if a == 1
    % do nothing
elseif a > N
    fpgSelectFileCall( N )
else
    fpgSelectFileCall( a-1 )
end

function pbNext_Callback(hObject, eventdata, handles)
[k,a] = fpgGetCurrent();
N = fileData(k,'Calls','Count','NoValidation',true);
if a >= N
    fpgSelectFileCall( N )
else
    fpgSelectFileCall( a+1 )
end
    

% --------------------------------------------------------------------
function beamComputeMenuItem_Callback(~,~, handles)
k = fpgGetCurrent();
A = str2num(get(handles.textIdx,'String'));
if ~isempty(A)
    for i = 1:length(A)
        calculateBeam(k,A(i));
    end
end
msgbox('Finished beam computation')


% --- Executes on button press in pbShowBeam.
function pbShowBeam_Callback(hObject, eventdata, handles)
A = str2num(get(handles.textIdx,'String'));
if isempty(A)
    fpgSelectFileCall( 0 );
else
    try
        fpgSelectFileCall( A(1) )
    catch err
        if strcmp(err.identifier, 'bats:fileCalls:outOfRange')
            msgbox(err.message);
        else
            throw(err);
        end
    end
end


% --- Executes on button press in pbSelectAll.
function pbSelectAll_Callback(hObject, eventdata, handles)
k = fpgGetCurrent();
N = fileData(k,'Calls','Count','NoValidation',true);
set(handles.textIdx,'String',strcat('1:',num2str(N)));


% --- Executes on button press in pbComputeBeam.
function pbComputeBeam_Callback(~, ~, handles)
beamComputeMenuItem_Callback([],[], handles)
