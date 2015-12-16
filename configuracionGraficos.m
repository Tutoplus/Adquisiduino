function varargout = configuracionGraficos(varargin)
% CONFIGURACIONGRAFICOS MATLAB code for configuracionGraficos.fig
%      CONFIGURACIONGRAFICOS, by itself, creates a new CONFIGURACIONGRAFICOS or raises the existing
%      singleton*.
%
%      H = CONFIGURACIONGRAFICOS returns the handle to a new CONFIGURACIONGRAFICOS or the handle to
%      the existing singleton*.
%
%      CONFIGURACIONGRAFICOS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CONFIGURACIONGRAFICOS.M with the given input arguments.
%
%      CONFIGURACIONGRAFICOS('Property','Value',...) creates a new CONFIGURACIONGRAFICOS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before configuracionGraficos_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to configuracionGraficos_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help configuracionGraficos

% Last Modified by GUIDE v2.5 14-Dec-2015 07:15:05

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @configuracionGraficos_OpeningFcn, ...
                   'gui_OutputFcn',  @configuracionGraficos_OutputFcn, ...
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


% --- Executes just before configuracionGraficos is made visible.
function configuracionGraficos_OpeningFcn(hObject, eventdata, handles, varargin)
movegui(hObject,'center');
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to configuracionGraficos (see VARARGIN)

% Choose default command line output for configuracionGraficos
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);



% UIWAIT makes configuracionGraficos wait for user response (see UIRESUME)
% uiwait(handles.pantallaConfGraficas);


% --- Outputs from this function are returned to the command line.
function varargout = configuracionGraficos_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

global linea;
global tiempo;
global y;
global n;
global stop;
global frecuenciaDeGraficado;
global N;


n = N;
global frecuencia;
frecuencia = frecuenciaDeGraficado;

linea= line(nan, nan, 'Color', [0.466  0.674  0.188],'LineWidth', 2);

set(handles.deslizadorN,'Value',N-1);
set(handles.deslizadorFrecuencia, 'Value', frecuencia-1);
set(handles.valorFrecuencia,'String', num2str(frecuencia));
set(handles.valorN,'String', num2str(n));

ylim([0 1]);
xlim([0 (n-1)/frecuencia]);
global t;
t = 0;
tiempo = linspace(0, (n-1)/frecuencia, n);
y = zeros(n,1);
set(linea,'XData',tiempo,'YData',y);
stop = false;
tic
axes(handles.grafico);

while stop == false;
    if toc > 1/frecuencia;
        tic;
        y(1:end-1) = y(2:end);
        y(end) = randi([5000, 5300])/6000;        
        set(linea,'XData',tiempo,'YData',y); 
        t = t+1/frecuencia;
        drawnow;
    end
end




function deslizadorN_Callback(hObject, eventdata, handles)
global frecuencia;
global n;
global linea;
global tiempo;
global t;
global y;

axes(handles.grafico);
n = fix(get(handles.deslizadorN, 'Value') + 50);
y = zeros(n,1);
tiempo = linspace(0, (n-1)/frecuencia, n);
t = 0;
xlim([0 (n-1)/frecuencia]);

set(handles.valorN,'String', num2str(n));

%set(linea1, 'Z',


% --- Executes during object creation, after setting all properties.
function deslizadorN_CreateFcn(hObject, eventdata, handles)
% hObject    handle to deslizadorN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function pantallaConfGraficas_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pantallaConfGraficas (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on slider movement.
function deslizadorFrecuencia_Callback(hObject, eventdata, handles)

global frecuencia;
global n;
global linea;
global tiempo;
global y;
frecuencia = fix(get(handles.deslizadorFrecuencia, 'Value') + 1);
y = zeros(n,1);
global t;
t = 0;
tiempo = linspace(0, (n-1)/frecuencia, n);
xlim([0 (n-1)/frecuencia]);
drawnow;
set(handles.valorFrecuencia,'String', num2str(frecuencia));


% --- Executes during object creation, after setting all properties.
function deslizadorFrecuencia_CreateFcn(hObject, eventdata, handles)
% hObject    handle to deslizadorFrecuencia (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


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

function valorN_CreateFcn(hObject, eventdata, handles)


% --- Executes when user attempts to close pantallaConfGraficas.
function pantallaConfGraficas_CloseRequestFcn(hObject, eventdata, handles)
global stop;
stop = true;
drawnow;
delete(hObject);


% --- Executes on button press in porDefectoBoton.
function porDefectoBoton_Callback(hObject, eventdata, handles)
set(handles.deslizadorN,'Value',250);
set(handles.deslizadorFrecuencia, 'Value', 15);
global n;
global frecuencia;
n = 250;
frecuencia = 15;
global y;
global tiempo;
global t;
y = zeros(n,1);

t = 0;
tiempo = linspace(0, (n-1)/frecuencia, n);
xlim([0 (n-1)/frecuencia]);




% --- Executes on button press in guardarBoton.
function guardarBoton_Callback(hObject, eventdata, handles)
global frecuenciaDeGraficado;
global frecuencia;
global N n;
N = n;
frecuenciaDeGraficado = frecuencia;
close;
