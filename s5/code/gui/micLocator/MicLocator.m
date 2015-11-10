function varargout = MicLocator(varargin)
% MICLOCATOR M-file for MicLocator.fig
%      MICLOCATOR, by itself, creates a new MICLOCATOR or raises the existing
%      singleton*.
%
%      H = MICLOCATOR returns the handle to a new MICLOCATOR or the handle to
%      the existing singleton*.
%
%      MICLOCATOR('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MICLOCATOR.M with the given input arguments.
%
%      MICLOCATOR('Property','Value',...) creates a new MICLOCATOR or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before MicLocator_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to MicLocator_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help MicLocator



% Last Modified by GUIDE v2.5 09-Nov-2015 20:30:47

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MicLocator_OpeningFcn, ...
                   'gui_OutputFcn',  @MicLocator_OutputFcn, ...
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


% --- Executes just before MicLocator is made visible.
function MicLocator_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to MicLocator (see VARARGIN)

% Choose default command line output for MicLocator
handles.output = hObject;

% input 1: MicAdmin Gui object.
handles.G.gui= varargin{1};

% clear global
global mobileLocEst;
mobileLocEst = [];

% Update handles structure
guidata(hObject, handles);

btnDefaults_Callback(handles.btnDefaults,eventdata,handles);



% UIWAIT makes MicLocator wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = MicLocator_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;




% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btnSelectSigFile.
function btnSelectSigFile_Callback(hObject, eventdata, handles)
% hObject    handle to btnSelectSigFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 [FileName,PathName] = uigetfile('*.wav','Select the outgoing signal file');
 set(handles.txtSignalFile, 'String', strcat(PathName,FileName));
 
 global SignalFileName;
 global SignalFilepath;
 
 SignalFileName=FileName;
 SignalFilepath = PathName;
 
  set(handles.lblSignalFile, 'String', SignalFileName);



% --- Executes during object creation, after setting all properties.
function txtSignalFile_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtSignalFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in btnSelectZeroDistFile.
function btnSelectZeroDistFile_Callback(hObject, eventdata, handles)
% hObject    handle to btnSelectZeroDistFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 [FileName,PathName] = uigetfile('*.wav','Select the zero distance signal file');
 set(handles.txtZeroDistFile, 'String', strcat(PathName,FileName));
 
 global ZeroDistFileName;
 global ZeroDistFilepath;
 
ZeroDistFileName=FileName;
 ZeroDistFilepath = PathName;
 
  set(handles.lblZeroDistFile, 'String', ZeroDistFileName);


% --- Executes during object creation, after setting all properties.
function txtZeroDistFile_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtZeroDistFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function txtSpeedCalFile_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtSpeedCalFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btnSelectSpeedCal.
function btnSelectSpeedCal_Callback(hObject, eventdata, handles)
% hObject    handle to btnSelectSpeedCal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 [FileName,PathName] = uigetfile('*.wav','Select the speed of sound calibration signal file');
 set(handles.txtSpeedCalFile, 'String', strcat(PathName,FileName));
 
 global SelectSpeedCalFileName;
 global SelectSpeedCalFilepath;
 
SelectSpeedCalFileName=FileName;
 SelectSpeedCalFilepath = PathName;
 
  set(handles.lblSpeedCalFile, 'String', SelectSpeedCalFileName);
  
  

% --- Executes on button press in btnLocate.
function btnLocate_Callback(hObject, eventdata, handles)
% hObject    handle to btnLocate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

try
 global mobileLocEst;
 global NumOfMics;
  set(handles.lblStatus, 'String', 'BUSY');
 
  CurrFile=get(handles.txtSignalFile, 'String');
   [wavSig,wavSigFs] = wavread(CurrFile);
   
   CurrFile=get(handles.txtZeroDistFile, 'String');
   [wavZero,wavZeroFs] = wavread(CurrFile);
   
   CurrFile=get(handles.txtSpeedCalFile, 'String');
   [wavSpeedCal,wavSpeedCalFs] = wavread(CurrFile);
   
    CurrFile=get(handles.txtFile1, 'String');
    [wavtxtFile1,wavtxtFile1Fs] = wavread(CurrFile); 
   
    CurrFile=get(handles.txtFile2, 'String');
    [wavtxtFile2,wavtxtFile2Fs] = wavread(CurrFile); 
   
    CurrFile=get(handles.txtFile3, 'String');
    [wavtxtFile3,wavtxtFile3Fs] = wavread(CurrFile); 
   
    CurrFile=get(handles.txtFile4, 'String');
    [wavtxtFile4,wavtxtFile4Fs] = wavread(CurrFile); 
   
    CurrFile=get(handles.txtFile5, 'String');
    [wavtxtFile5,wavtxtFile5Fs] = wavread(CurrFile); 

   wavSig=fliplr(wavSig);
    
    ZeroChannelNum = str2double(get(handles.txtZeroChannel, 'String'));
    
if get(handles.cbZero, 'Value')
    
    ZeroDistancecm=str2double(get(handles.txtZeroOverride, 'String'));
    ZerolagDiff = -1*(ZeroDistancecm.*wavtxtFile5Fs)./(350*100);
else
     %Calculate zero distance offset
     [w,lag] = xcorr(wavSig,wavZero(:,ZeroChannelNum));
    [~,I] = max(abs(w));
    ZerolagDiff = lag(I);
end

    if get(handles.cbSpeed, 'Value')
        SpeedOfSound = str2double(get(handles.txtSpeedOverride, 'String'));
    else
    %Calculate the speed of sound (assuming 1m)
        [w,lag] = xcorr(wavSig,wavSpeedCal(:,ZeroChannelNum ));
        [~,I] = max(abs(w));
        Diff = -lag(I);
        Diff = Diff + ZerolagDiff;
        timeDiff = Diff/wavSpeedCalFs;
        SpeedOfSound = 1/timeDiff;
    end


NumOfMics = str2double(get(handles.txtMicNum, 'String'));


%Load mic coordinates
 CurrFile=get(handles.txtSelectSpeakerLocFile, 'String');
MicLoc= dlmread(CurrFile);

mobileLocEst1=zeros(3,NumOfMics);
mobileLocEst2=zeros(3,NumOfMics);
R=zeros(5,NumOfMics);
for CurrSpkr = 1:NumOfMics

     %Calculate distances
[w,lag] = xcorr(wavSig,wavtxtFile1(:,CurrSpkr ));
[~,I] = max(abs(w));
Diff = -lag(I);
Diff = Diff +ZerolagDiff;
R(1,CurrSpkr)=1*(Diff)./wavtxtFile1Fs.*SpeedOfSound;
    
[w,lag] = xcorr(wavSig,wavtxtFile2(:,CurrSpkr ));
[~,I] = max(abs(w));
Diff = -lag(I);
Diff = Diff +ZerolagDiff;
R(2,CurrSpkr)=1*(Diff)./wavtxtFile2Fs.*SpeedOfSound;

[w,lag] = xcorr(wavSig,wavtxtFile3(:,CurrSpkr ));
[~,I] = max(abs(w));
Diff = -lag(I);
Diff = Diff +ZerolagDiff;
R(3,CurrSpkr)=1*(Diff)./wavtxtFile3Fs.*SpeedOfSound;

[w,lag] = xcorr(wavSig,wavtxtFile4(:,CurrSpkr ));
[~,I] = max(abs(w));
Diff = -lag(I);
Diff = Diff +ZerolagDiff;
R(4,CurrSpkr)=1*(Diff)./wavtxtFile4Fs.*SpeedOfSound;

[w,lag] = xcorr(wavSig,wavtxtFile5(:,CurrSpkr ));
[~,I] = max(abs(w));
Diff = -lag(I);
Diff = Diff +ZerolagDiff;
R(5,CurrSpkr)=1*(Diff)./wavtxtFile5Fs.*SpeedOfSound;
    

    if get(handles.rbTri, 'Value')
        
         mobileLocEst1(:,CurrSpkr ) = tri( MicLoc,R(:,CurrSpkr) );
    
    elseif get(handles.rbMulti, 'Value')
         mobileLocEst1(:,CurrSpkr )= multi( 5,3,SpeedOfSound,transpose(R(:,CurrSpkr)) ,MicLoc);
    end
    
    mobileLocEst = mobileLocEst1;
    
    if get(handles.cbGN, 'Value')
        numOfIteration = 15;
       mobileLocEst2(:,CurrSpkr )  = gaussnewton( MicLoc ,transpose(mobileLocEst1(:,CurrSpkr )),numOfIteration,5, R(:,CurrSpkr)) 
       mobileLocEst = mobileLocEst2;
    end
end

ZeroDistace = -1*(ZerolagDiff)./wavtxtFile5Fs.*SpeedOfSound;
ZeroDistancecm = ZeroDistace*100;
set(handles.txtZero, 'String',  strcat(num2str(ZeroDistancecm) ,'  [cm]'));

set(handles.txtSpeedOfSound, 'String',strcat(num2str(SpeedOfSound) ,'  [m/s]'))
  set(handles.lblStatus, 'String', 'DONE!');
msgbox(sprintf('Finished.\nPlease click "Send to batalef & close" if you are satisfied with the results'));
catch
    msgbox('Error');
    set(handles.lblStatus, 'String', 'ERROR');
end



% --- Executes on button press in btnDefaults.
function btnDefaults_Callback(hObject, eventdata, handles)
% hObject    handle to btnDefaults (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

fid = fopen('defaults.txt');

tline = fgetl(fid);

[PathName,FileName,ext] = fileparts(tline) ;
tline = fgetl(fid);
 set(handles.txtSignalFile, 'String', strcat(PathName,'\',FileName,ext));
 global SignalFileName;
 global SignalFilepath;
 SignalFileName=strcat(FileName,ext);
 SignalFilepath = PathName;
 set(handles.lblSignalFile, 'String', SignalFileName);
  
  
[PathName,FileName,ext] = fileparts(tline) ;
tline = fgetl(fid);
 set(handles.txtZeroDistFile, 'String', strcat(PathName,'\',FileName,ext));
 global ZeroDistFileName;
 global ZeroDistFilepath;
ZeroDistFileName=strcat(FileName,ext);
 ZeroDistFilepath = PathName;
  set(handles.lblZeroDistFile, 'String', ZeroDistFileName);
  
  
  
  [PathName,FileName,ext] = fileparts(tline) ;
tline = fgetl(fid);
 set(handles.txtSpeedCalFile, 'String', strcat(PathName,'\',FileName,ext));
 global SelectSpeedCalFileName;
 global SelectSpeedCalFilepath;
SelectSpeedCalFileName=strcat(FileName,ext);
 SelectSpeedCalFilepath = PathName;
 set(handles.lblSpeedCalFile, 'String', SelectSpeedCalFileName);
  
  
  
  
[PathName,FileName,ext] = fileparts(tline) ;
tline = fgetl(fid);
set(handles.txtSelectSpeakerLocFile, 'String', strcat(PathName,'\',FileName,ext)); 
 global SpeakerLocFileName;
 global SpeakerLocFilepath;
SpeakerLocFileName=strcat(FileName,ext);
SpeakerLocFilepath = PathName;
  set(handles.lblSpeakerLocFile, 'String', SpeakerLocFileName);
  
  
  
  
  
[PathName,FileName,ext] = fileparts(tline) ;
tline = fgetl(fid);
set(handles.txtFile1, 'String', strcat(PathName,'\',FileName,ext));
 global File1Name;
 global File1path;
File1Name=strcat(FileName,ext);
File1path = PathName;
 set(handles.lblFile1, 'String', File1Name);
  
[PathName,FileName,ext] = fileparts(tline) ;
set(handles.txtFile2, 'String', strcat(PathName,'\',FileName,ext));
tline = fgetl(fid);
 global File2Name;
 global File2path;
File2Name=strcat(FileName,ext);
File2path = PathName;
 set(handles.lblFile2, 'String', File2Name);

[PathName,FileName,ext] = fileparts(tline) ;
tline = fgetl(fid);
set(handles.txtFile3, 'String', strcat(PathName,'\',FileName,ext));
 global File3Name;
 global File3path;
File3Name=strcat(FileName,ext);
File3path = PathName;
 set(handles.lblFile3, 'String', File3Name);

[PathName,FileName,ext] = fileparts(tline) ;
tline = fgetl(fid);
set(handles.txtFile4, 'String', strcat(PathName,'\',FileName,ext));
 global File4Name;
 global File4path;
File4Name=strcat(FileName,ext);
File4path = PathName;
 set(handles.lblFile4, 'String', File4Name);
 
 [PathName,FileName,ext] = fileparts(tline) ;
tline = fgetl(fid);
set(handles.txtFile5, 'String', strcat(PathName,'\',FileName,ext));
 global File5Name;
 global File5path;
File5Name=strcat(FileName,ext);
File5path = PathName;
 set(handles.lblFile5, 'String', File5Name);
 
fclose(fid);



% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1


% --- Executes on button press in checkbox2.
function checkbox2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox2


% --- Executes on button press in checkbox3.
function checkbox3_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox3


% --- Executes on button press in btnSelect1.
function btnSelect1_Callback(hObject, eventdata, handles)
% hObject    handle to btnSelect1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 [FileName,PathName] = uigetfile('*.wav','Select Microphone return file for speaker 1');
 set(handles.txtFile1, 'String', strcat(PathName,FileName));
 
 global File1Name;
 global File1path;
 
File1Name=FileName;
File1path = PathName;
 
  set(handles.lblFile1, 'String', File1Name);


% --- Executes during object creation, after setting all properties.
function txtFile1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtFile1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btnLoad1.
function btnLoad1_Callback(hObject, eventdata, handles)
% hObject    handle to btnLoad1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in btnLoad2.
function btnLoad2_Callback(hObject, eventdata, handles)
% hObject    handle to btnLoad2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function txtFile2_Callback(hObject, eventdata, handles)
% hObject    handle to txtFile2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtFile2 as text
%        str2double(get(hObject,'String')) returns contents of txtFile2 as a double


% --- Executes during object creation, after setting all properties.
function txtFile2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtFile2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btnSelect2.
function btnSelect2_Callback(hObject, eventdata, handles)
% hObject    handle to btnSelect2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 [FileName,PathName] = uigetfile('*.wav','Select Microphone return file for speaker 2');
 set(handles.txtFile2, 'String', strcat(PathName,FileName));
 
 global File2Name;
 global File2path;
 
File2Name=FileName;
File2path = PathName;
 
  set(handles.lblFile2, 'String', File2Name);


% --- Executes on button press in btnLoad3.
function btnLoad3_Callback(hObject, eventdata, handles)
% hObject    handle to btnLoad3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function txtFile3_Callback(hObject, eventdata, handles)
% hObject    handle to txtFile3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtFile3 as text
%        str2double(get(hObject,'String')) returns contents of txtFile3 as a double


% --- Executes during object creation, after setting all properties.
function txtFile3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtFile3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btnSelect3.
function btnSelect3_Callback(hObject, eventdata, handles)
% hObject    handle to btnSelect3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 [FileName,PathName] = uigetfile('*.wav','Select Microphone return file for speaker 3');
 set(handles.txtFile3, 'String', strcat(PathName,FileName));
 
 global File3Name;
 global File3path;
 
File3Name=FileName;
File3path = PathName;
 
  set(handles.lblFile3, 'String', File3Name);



% --- Executes on button press in btnLoad4.
function btnLoad4_Callback(hObject, eventdata, handles)
% hObject    handle to btnLoad4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function txtFile4_Callback(hObject, eventdata, handles)
% hObject    handle to txtFile4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtFile4 as text
%        str2double(get(hObject,'String')) returns contents of txtFile4 as a double


% --- Executes during object creation, after setting all properties.
function txtFile4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtFile4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btnSelect4.
function btnSelect4_Callback(hObject, eventdata, handles)
% hObject    handle to btnSelect4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 [FileName,PathName] = uigetfile('*.wav','Select Microphone return file for speaker 4');
 set(handles.txtFile4, 'String', strcat(PathName,FileName));
 
 global File4Name;
 global File4path;
 
File4Name=FileName;
File4path = PathName;
 
  set(handles.lblFile4, 'String', File4Name);


% --- Executes on button press in btnLoad5.
function btnLoad5_Callback(hObject, eventdata, handles)
% hObject    handle to btnLoad5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function txtFile5_Callback(hObject, eventdata, handles)
% hObject    handle to txtFile5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtFile5 as text
%        str2double(get(hObject,'String')) returns contents of txtFile5 as a double


% --- Executes during object creation, after setting all properties.
function txtFile5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtFile5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btnSelect5.
function btnSelect5_Callback(hObject, eventdata, handles)
% hObject    handle to btnSelect5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 [FileName,PathName] = uigetfile('*.wav','Select Microphone return file for speaker 5');
 set(handles.txtFile5, 'String', strcat(PathName,FileName));
 
 global File5Name;
 global File5path;
 
File5Name=FileName;
File5path = PathName;
 
  set(handles.lblFile5, 'String', File5Name);

% --- Executes on button press in btnPlot.
function btnPlot_Callback(hObject, eventdata, handles)
% hObject    handle to btnPlot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

 global mobileLocEst;
 global NumOfMics ;

 figure('Name','X Z Plot','NumberTitle','off')
  plot(mobileLocEst(1,:),mobileLocEst(3,:),'*w')
  for i=1:NumOfMics 
      str = num2str(i);
    text(mobileLocEst(1,i),mobileLocEst(3,i),str,'HorizontalAlignment','right')
  end
 set(gca,'XDir','reverse')
 title('Top view')
 xlabel('X') % x-axis label
ylabel('Z') % y-axis label


 figure('Name','X Y Plot','NumberTitle','off')
 plot(mobileLocEst(1,:),mobileLocEst(2,:),'*w')
   for i=1:NumOfMics 
      str = num2str(i);
    text(mobileLocEst(1,i),mobileLocEst(2,i),str,'HorizontalAlignment','right')
  end
  set(gca,'XDir','reverse')
  title('Front view')
  xlabel('X') % x-axis label
ylabel('Y') % y-axis label

 figure('Name','Coordinates','NumberTitle','off')

uitable('Data',transpose(mobileLocEst), 'ColumnName', {'X', 'Y', 'Z'});



% --- Executes on button press in btnSelectSpeakerLoc.
function btnSelectSpeakerLoc_Callback(hObject, eventdata, handles)
% hObject    handle to btnSelectSpeakerLoc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 [FileName,PathName] = uigetfile('*.txt','Select theSpeaker location file');
 set(handles.txtSelectSpeakerLocFile, 'String', strcat(PathName,FileName));
 
 global SpeakerLocFileName;
 global SpeakerLocFilepath;
 
SpeakerLocFileName=FileName;
SpeakerLocFilepath = PathName;
 
  set(handles.lblSpeakerLocFile, 'String', SpeakerLocFileName);



function txtSelectSpeakerLocFile_Callback(hObject, eventdata, handles)
% hObject    handle to txtSelectSpeakerLocFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtSelectSpeakerLocFile as text
%        str2double(get(hObject,'String')) returns contents of txtSelectSpeakerLocFile as a double


% --- Executes during object creation, after setting all properties.
function txtSelectSpeakerLocFile_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtSelectSpeakerLocFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btnLoadSpeakerLoc.
function btnLoadSpeakerLoc_Callback(hObject, eventdata, handles)
% hObject    handle to btnLoadSpeakerLoc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in btnExport.
function btnExport_Callback(hObject, eventdata, handles)
% hObject    handle to btnExport (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global mobileLocEst;
if isempty(mobileLocEst)
    msgbox('No locations found');
else
    % send & close
    if handles.G.gui.changePositions(mobileLocEst');
        delete(handles.figure1);
    end
end



% --- Executes on button press in cbGN.
function cbGN_Callback(hObject, eventdata, handles)
% hObject    handle to cbGN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cbGN


% --- Executes during object creation, after setting all properties.
function txtZero_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtZero (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on key press with focus on cbGN and none of its controls.
function cbGN_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to cbGN (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)



function txtMicNum_Callback(hObject, eventdata, handles)
% hObject    handle to txtMicNum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtMicNum as text
%        str2double(get(hObject,'String')) returns contents of txtMicNum as a double


% --- Executes during object creation, after setting all properties.
function txtMicNum_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtMicNum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txtZeroChannel_Callback(hObject, eventdata, handles)
% hObject    handle to txtZeroChannel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtZeroChannel as text
%        str2double(get(hObject,'String')) returns contents of txtZeroChannel as a double


% --- Executes during object creation, after setting all properties.
function txtZeroChannel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtZeroChannel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in cbZero.
function cbZero_Callback(hObject, eventdata, handles)
% hObject    handle to cbZero (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cbZero


% --- Executes on button press in cbSpeed.
function cbSpeed_Callback(hObject, eventdata, handles)
% hObject    handle to cbSpeed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cbSpeed



function txtZeroOverride_Callback(hObject, eventdata, handles)
% hObject    handle to txtZeroOverride (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtZeroOverride as text
%        str2double(get(hObject,'String')) returns contents of txtZeroOverride as a double


% --- Executes during object creation, after setting all properties.
function txtZeroOverride_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtZeroOverride (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txtSpeedOverride_Callback(hObject, eventdata, handles)
% hObject    handle to txtSpeedOverride (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtSpeedOverride as text
%        str2double(get(hObject,'String')) returns contents of txtSpeedOverride as a double


% --- Executes during object creation, after setting all properties.
function txtSpeedOverride_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtSpeedOverride (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
global mobileLocEst;
if ~isempty(mobileLocEst)
    A = questdlg('Send new positions to batalef?','Exit','Yes','No','Cancel','Cancel');
    if strcmp(A,'Yes')
        if ~handles.G.gui.changePositions(mobileLocEst');
            return;
        end
    elseif strcmp(A,'Cancel')
        return; % user abort
    end
end
delete(hObject);