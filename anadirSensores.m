function varargout = anadirSensores(varargin)
% ANADIRSENSORES MATLAB code for anadirSensores.fig
%      ANADIRSENSORES, by itself, creates a new ANADIRSENSORES or raises the existing
%      singleton*.
%
%      H = ANADIRSENSORES returns the handle to a new ANADIRSENSORES or the handle to
%      the existing singleton*.
%
%      ANADIRSENSORES('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ANADIRSENSORES.M with the given input arguments.
%
%      ANADIRSENSORES('Property','Value',...) creates a new ANADIRSENSORES or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before anadirSensores_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to anadirSensores_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help anadirSensores

% Last Modified by GUIDE v2.5 11-Dec-2015 04:08:45

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @anadirSensores_OpeningFcn, ...
                   'gui_OutputFcn',  @anadirSensores_OutputFcn, ...
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


% --- Executes just before anadirSensores is made visible.
function anadirSensores_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to anadirSensores (see VARARGIN)

% Choose default command line output for anadirSensores
movegui(hObject,'center');
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes anadirSensores wait for user response (see UIRESUME)
% uiwait(handles.figure1);

global datos;
load sensores.mat;
datos = table2cell(sensores);
set(handles.tablaSensores,'Data',datos); 



% --- Outputs from this function are returned to the command line.
function varargout = anadirSensores_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
load sensores.mat;


% --- Executes on button press in guardarBoton.
function guardarBoton_Callback(hObject, eventdata, handles)
global datos;
datos = get(handles.tablaSensores, 'Data');
nuevosDatos = cell2table(datos,...
'VariableNames',{'Var1' 'Var2' 'Var3'  'Var4' 'Var5'});
sensores = nuevosDatos;
save('sensores.mat','sensores');
close;



% --- Executes on button press in anadirSensorBoton.
function anadirSensorBoton_Callback(hObject, eventdata, handles)
global datos;
datos = get(handles.tablaSensores, 'Data');
datos(end+1,:) = {'Sensor' 's*1' 'U' [0] [100]};
set(handles.tablaSensores,'Data',datos); 


% --- Executes on button press in eliminarFilaBoton.
function eliminarFilaBoton_Callback(hObject, eventdata, handles)
try
    set(handles.tablaSensores,'CellSelectionCallBack',@(h,e) set(h,'UserData',e))
    D=get(handles.tablaSensores,'Data');
    Index=get(handles.tablaSensores,'UserData');
    D(Index.Indices(1),:)=[];
    set(handles.tablaSensores,'Data',D);
catch
end


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)

delete(hObject);
