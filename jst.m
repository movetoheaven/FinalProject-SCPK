function varargout = jst(varargin)
% JST MATLAB code for jst.fig
%      JST, by itself, creates a new JST or raises the existing
%      singleton*.
%
%      H = JST returns the handle to a new JST or the handle to
%      the existing singleton*.
%
%      JST('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in JST.M with the given input arguments.
%
%      JST('Property','Value',...) creates a new JST or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before jst_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to jst_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help jst

% Last Modified by GUIDE v2.5 27-May-2022 00:03:06

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @jst_OpeningFcn, ...
                   'gui_OutputFcn',  @jst_OutputFcn, ...
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


% --- Executes just before jst is made visible.
function jst_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to jst (see VARARGIN)

% Choose default command line output for jst
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes jst wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = jst_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in show.
function show_Callback(hObject, eventdata, handles)
% hObject    handle to show (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%show data %
dataset = readcell('diabetes.csv', 'Range', 'A2:E769');
header = readcell('diabetes.csv', 'Range', 'A1:E1');
set(handles.table, 'Data', dataset, 'ColumnName', header);

function weight_Callback(hObject, eventdata, handles)
% hObject    handle to weight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of weight as text
%        str2double(get(hObject,'String')) returns contents of weight as a double


% --- Executes during object creation, after setting all properties.
function weight_CreateFcn(hObject, eventdata, handles)
% hObject    handle to weight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in submit.
function submit_Callback(hObject, eventdata, handles)
% hObject    handle to submit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
data_latih = xlsread('diabetes.csv',1,'P7:S734');
target_latih = xlsread('diabetes.csv',1,'H7:H734');

data_latih = data_latih';
target_latih = target_latih';

Bp = str2double(get(handles.blood,'string'));
In = str2double(get(handles.insulin,'string'));
Bmi = str2double(get(handles.bmi,'string'));
Age = str2double(get(handles.age,'string'));


n = [Bp In Bmi Age];
maxN = max(n);
minN = min(n);
selisih = maxN - minN;

Bp = ((Bp - minN)/selisih);
In = ((In - minN)/selisih);
Bmi = ((Bmi - minN)/selisih);
Age = ((Age - minN)/selisih);

m = [Bp In Bmi Age];
m = m';

net = newlin([0 1; 0 1; 0 1; 0 1], 1);
net.IW{1,1,1,1} = [1 -1 1 -1]; 
net.b{1} = [1];

net.trainParam.epochs = 100;
net = train(net, data_latih, target_latih);
a = sim(net, m);
%e = a - target_latih;

% mendapatkan nilai weight dan bias baru
net.IW{1,1,1,1,1}; %= [0.5705 0.0068 1.1679];
net.b{1}; %= [3016008];

glucose = ((((a-0.1)*(selisih))/0.8)+minN);
set(handles.glu,'string',glucose);



function result_Callback(hObject, eventdata, handles)
% hObject    handle to result (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of result as text
%        str2double(get(hObject,'String')) returns contents of result as a double


% --- Executes during object creation, after setting all properties.
function result_CreateFcn(hObject, eventdata, handles)
% hObject    handle to result (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function insulin_Callback(hObject, eventdata, handles)
% hObject    handle to insulin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of insulin as text
%        str2double(get(hObject,'String')) returns contents of insulin as a double


% --- Executes during object creation, after setting all properties.
function insulin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to insulin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function blood_Callback(hObject, eventdata, handles)
% hObject    handle to blood (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of blood as text
%        str2double(get(hObject,'String')) returns contents of blood as a double


% --- Executes during object creation, after setting all properties.
function blood_CreateFcn(hObject, eventdata, handles)
% hObject    handle to blood (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function glu_Callback(hObject, eventdata, handles)
% hObject    handle to glu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of glu as text
%        str2double(get(hObject,'String')) returns contents of glu as a double


% --- Executes during object creation, after setting all properties.
function glu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to glu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function age_Callback(hObject, eventdata, handles)
% hObject    handle to age (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of age as text
%        str2double(get(hObject,'String')) returns contents of age as a double


% --- Executes during object creation, after setting all properties.
function age_CreateFcn(hObject, eventdata, handles)
% hObject    handle to age (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function bmi_Callback(hObject, eventdata, handles)
% hObject    handle to bmi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of bmi as text
%        str2double(get(hObject,'String')) returns contents of bmi as a double


% --- Executes during object creation, after setting all properties.
function bmi_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bmi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in reset.
function reset_Callback(hObject, eventdata, handles)
% hObject    handle to reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.blood,'string','');
set(handles.insulin,'string','');
set(handles.bmi,'string','');
set(handles.age,'string','');
set(handles.glu,'string','');

