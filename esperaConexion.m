function varargout = esperaConexion(varargin)
% ESPERACONEXION MATLAB code for esperaConexion.fig
%      ESPERACONEXION, by itself, creates a new ESPERACONEXION or raises the existing
%      singleton*.
%
%      H = ESPERACONEXION returns the handle to a new ESPERACONEXION or the handle to
%      the existing singleton*.
%
%      ESPERACONEXION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ESPERACONEXION.M with the given input arguments.
%
%      ESPERACONEXION('Property','Value',...) creates a new ESPERACONEXION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before esperaConexion_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to esperaConexion_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help esperaConexion

% Last Modified by GUIDE v2.5 03-Dec-2015 17:25:21

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @esperaConexion_OpeningFcn, ...
                   'gui_OutputFcn',  @esperaConexion_OutputFcn, ...
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


% --- Executes just before esperaConexion is made visible.
function esperaConexion_OpeningFcn(hObject, eventdata, handles, varargin)
movegui(hObject, 'center'); 
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

iconsClassName = 'com.mathworks.widgets.BusyAffordance$AffordanceSize';
iconsSizeEnums = javaMethod('values',iconsClassName);
SIZE_32x32 = iconsSizeEnums(1);  % (1) = 16x16,  (2) = 32x32
jObj = com.mathworks.widgets.BusyAffordance(SIZE_32x32, 'testing...');  % icon, label

jObj.setPaintsWhenStopped(true);  % default = false
jObj.useWhiteDots(false);         % default = false (true is good for dark backgrounds)
javacomponent(jObj.getComponent, [190,13,100,60], gcf);
jObj.start;
    % do some long operation...
jObj.setBusyText('Espere Por Favor');                  % default = false


% --- Outputs from this function are returned to the command line.
function varargout = esperaConexion_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
