function varargout = Acerca(varargin)
% ACERCA MATLAB code for Acerca.fig
%      ACERCA, by itself, creates a new ACERCA or raises the existing
%      singleton*.
%
%      H = ACERCA returns the handle to a new ACERCA or the handle to
%      the existing singleton*.
%
%      ACERCA('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ACERCA.M with the given input arguments.
%
%      ACERCA('Property','Value',...) creates a new ACERCA or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Acerca_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Acerca_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Acerca

% Last Modified by GUIDE v2.5 14-Dec-2015 01:10:22

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Acerca_OpeningFcn, ...
                   'gui_OutputFcn',  @Acerca_OutputFcn, ...
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


% --- Executes just before Acerca is made visible.
function Acerca_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Acerca (see VARARGIN)

% Choose default command line output for Acerca
movegui(hObject,'center');
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Acerca wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Acerca_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in aceptarBoton.
function aceptarBoton_Callback(hObject, eventdata, handles)
close;
