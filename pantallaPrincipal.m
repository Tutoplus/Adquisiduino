function varargout = pantallaPrincipal(varargin)

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @pantallaPrincipal_OpeningFcn, ...
    'gui_OutputFcn',  @pantallaPrincipal_OutputFcn, ...
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

function pantallaPrincipal_OpeningFcn(hObject, eventdata, handles, varargin)
movegui(hObject,'center');
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

%clc;
%clear all;
global conectado;

global frecuenciaDeGraficado;
frecuenciaDeGraficado = 15;
global obteniendoDatos;
global capturandoDatos;
global primeraCaptura;
primeraCaptura = false;
global tiempo;

global N;
N = 250;



obteniendoDatos = false;
capturandoDatos = false;

%variables que almacenaran los valores de voltaje leido por los 5 sensores

conectado = false;




function varargout = pantallaPrincipal_OutputFcn(hObject, eventdata, handles)

varargout{1} = handles.output;
set(handles.grafico1, 'Position', [62, 10.154, 143, 37], 'Visible', 'on' );
global im;
im = imread('iconos\no-confirm.jpg');
axes(handles.okPaso1);
image (im);
axis off;
axes(handles.okPaso2);
image (im);
axis off;
axes(handles.okPaso3);
image (im);
axis off;
axes(handles.okPaso4);
image (im);
axis off;
drawnow;

set(handles.iniciarPararCapturaBoton,'String','Iniciar Captura De Datos', 'ForegroundColor', [0 0.498 0]);
set(handles.guardarDatosBoton, 'Enable', 'off');
set(handles.tablaDeDatos, 'Data', []);
set(handles.grafico2, 'Visible', 'off');
set(handles.grafico3, 'Visible', 'off');
set(handles.grafico4, 'Visible', 'off');
set(handles.grafico5, 'Visible', 'off');

if toolboxInstalado() == true
    set(handles.escanearPuertoBoton, 'Enable', 'on');
else
    set(handles.indicarS2, 'Visible', 'off');
    set(handles.indicarS3, 'Visible', 'off');
    set(handles.indicarS4, 'Visible', 'off');
    set(handles.indicarS5, 'Visible', 'off');
    
    set(handles.barraDeEstado, 'BackgroundColor',[0.863 0.0 0.137]);
    set(handles.mensajeError, 'Visible', 'on');
    set(handles.instalarPaqueteBoton, 'Visible', 'on');
    
end





function escanearPuertoBoton_Callback(hObject, eventdata, handles)
global conectado;

listaDePuertos = escanearPuertos();
for i = 1:1:size(listaDePuertos,1)
    lisDePuertosTexto(i) = listaDePuertos(i,1);
end
set(handles.ListaDePuertos, 'String',  lisDePuertosTexto);
set(handles.ListaDePuertos, 'Enable', 'on');
set(handles.establecerConexionBoton,'Enable', 'on');
set(handles.listaPlacas, 'Enable', 'on');





function ListaDePuertos_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Untitled_1_Callback(hObject, eventdata, handles)


function establecerConexionBoton_Callback(hObject, eventdata, handles)
global conectado;
global listaDePuertos;
global arduinoPlaca;
global capturandoDatos;
global mostrandoDatos;
global obteniendoDatos;

puertosCOM = get(handles.ListaDePuertos,'String');
puertoCOM = puertosCOM{get(handles.ListaDePuertos,'Value')};
placas = get(handles.listaPlacas, 'Value');

if conectado == false
    set(handles.tablaDeDatos, 'Data', []);
    set(handles.tablaDeDatos,'ColumnName',{});
    cla(handles.grafico1);
    cla(handles.grafico2);
    cla(handles.grafico3);
    cla(handles.grafico4);
    cla(handles.grafico5);
    try
        run esperaConexion;
        pause(0.2);
        switch placas
            case 1
                arduinoPlaca = arduino(puertoCOM);
            case 2
                arduinoPlaca = arduino(puertoCOM, 'uno');
            case 3
                arduinoPlaca = arduino(puertoCOM, 'Mega2560');
            case 4
                arduinoPlaca = arduino(puertoCOM, 'MegaADK');
            case 5
                arduinoPlaca = arduino(puertoCOM, 'Nano3');
            case 6
                arduinoPlaca = arduino(puertoCOM, 'Mini');
            case 7
                arduinoPlaca = arduino(puertoCOM, 'ProMini328_5V');
            case 8
                arduinoPlaca = arduino(puertoCOM, 'ProMini328_3V');
            case 9
                arduinoPlaca = arduino(puertoCOM, 'Micro');
            case 10
                arduinoPlaca = arduino(puertoCOM, 'Due');
            case 11
                arduinoPlaca = arduino(puertoCOM, 'Leonardo');
            case 12
                arduinoPlaca = arduino(puertoCOM, 'Pro328_5V');
            case 13
                arduinoPlaca = arduino(puertoCOM, 'Pro328_3V');
            case 14
                arduinoPlaca = arduino(puertoCOM, 'Fio');
            case 15
                arduinoPlaca = arduino(puertoCOM, 'DigitalSandbox');
                
        end
        if placas >= 2 && placas <=15
            mensajeDeConfirmacion = ['Conexión establecida satisfactoriamente. Se ha detectado una placa Genuino ', arduinoPlaca.Board, ' conectado en el puerto ',puertoCOM, '. El siguiente paso es configurar los tipos de sensores conectados y los puerto analógicos de Arduino/Genuino donde están conectados' ];
            
        elseif placas == 1
            mensajeDeConfirmacion = ['Conexión establecida satisfactoriamente. Se ha detectado una placa oficial Arduino ', arduinoPlaca.Board, ' conectado en el puerto ',puertoCOM, '. El siguiente paso es configurar los tipos de sensores conectados y los puerto analógicos de Arduino donde están conectados' ];
            
        end
        
        listaDePuertos = arduinoPlaca.AvailablePins;
        conectado = true;
        close(esperaConexion);
        h = msgbox(mensajeDeConfirmacion, 'Conexión Satisfactoria');
        uiwait;
        set(handles.establecerConexionBoton, 'String', 'Finalizar Conexión','ForegroundColor','red');
        set(handles.escanearPuertoBoton,'Enable', 'off');
        tooltip = ['Finalizar la conexión con Arduino ', arduinoPlaca.Board];
        set(handles.establecerConexionBoton,'TooltipString',tooltip);
        
        %set(handles.establecerConexionBoton,'Enable', 'off');
        
        
        if isequal(conectado,true)
            
            set(handles.seleccionCantidadSensores,'Enable','on');
            set(handles.ListaDePuertos, 'Enable', 'off');
            set(handles.listaPlacas, 'Enable', 'off');
            set(handles.etiquetaModelo, 'Enable', 'on');
            set(handles.modeloArduino,'String',arduinoPlaca.Board);
            set(handles.anadirSensoresBoton, 'Enable', 'on');
            set(handles.guardarNumeroSensoresBoton,'Enable', 'on');
            
            axes(handles.okPaso1);
            im = imread('iconos\confirm.jpg');
            image(im);
            axis off;
            drawnow;
            
            
        end
        
    catch exception
        disp('Error:');
        disp(exception.identifier);
        
        if strcmp(exception.identifier,'MATLAB:arduinoio:general:invalidPort') || strcmp(exception.identifier,'MATLAB:arduinoio:general:failedUpload') ;
            set(handles.establecerConexionBoton, 'String', 'Establecer Conexión','ForegroundColor',[0.0 0.498 0]);
            conectado = false;
            close(esperaConexion);
            mensajeDeError = ['No se ha detectado hardware Arduino conectado en el Puerto Serial ', puertoCOM, '. Por favor vuelva a escanear e intente conectar en otro puerto Serial. Si usted está usando una placa Genuino (no oficial), deberá especificar el modelo de la misma para establecer conexión satisfactoriamente.'];
            h = msgbox(mensajeDeError, 'Error','error');
            
        end
        
    end
    
    
elseif (conectado == true)
    h = msgbox('Se ha finalizado la conexión con Arduino', 'Conexión Finalizada');
    uiwait;
    set(handles.establecerConexionBoton, 'String', 'Establecer Conexión','ForegroundColor',[0.0 0.498 0]);
    set(handles.establecerConexionBoton,'TooltipString','Intentar establecer conexión con el hardware de Arduino en puerto COM seleccionado');
    set(handles.escanearPuertoBoton,'Enable', 'on');
    set(handles.ListaDePuertos, 'Enable', 'on');
    set(handles.guardarNumeroSensoresBoton,'Enable', 'off');
    set(handles.seleccionCantidadSensores,'Enable','off');
    set(handles.guardarPeriodoBoton, 'Enable', 'off');
    set(handles.iniciarPararCapturaBoton, 'Enable', 'off');
    set(handles.opcionPeriodo, 'Enable', 'off');
    set(handles.opcionFrecuencia, 'Enable', 'off');
    set(handles.valorOpcionFrecuencia, 'Enable', 'off');
    set(handles.valorOpcionPeriodo, 'Enable', 'off');
    
    
    obteniendoDatos = false;
    mostrandoDatos = false;
    capturandoDatos = false;
    conectado = false;
    
    im = imread('iconos/no-confirm.jpg');
    axes(handles.okPaso1);
    image (im);
    axis off;
    axes(handles.okPaso2);
    image (im);
    axis off;
    axes(handles.okPaso3);
    image (im);
    axis off;
    axes(handles.okPaso4);
    image (im);
    axis off;
    drawnow;
    arduinoPlaca = 0;
    
    %volvemos la barra de estado a su color inicial
    
    set(handles.iniciarPararCapturaBoton,'String','Iniciar Captura De Datos', 'ForegroundColor', [0 0.498 0]);
    set(handles.barraDeEstado, 'BackgroundColor',[0.31 0.31 0.31]);
    set(handles.indicarS1, 'BackgroundColor',[0.31 0.31 0.31]);
    set(handles.indicarS2, 'BackgroundColor',[0.31 0.31 0.31]);
    set(handles.indicarS3, 'BackgroundColor',[0.31 0.31 0.31]);
    set(handles.indicarS4, 'BackgroundColor',[0.31 0.31 0.31]);
    set(handles.indicarS5, 'BackgroundColor',[0.31 0.31 0.31]);
    
    set(handles.valS1, 'BackgroundColor',[0.31 0.31 0.31]);
    set(handles.valS2, 'BackgroundColor',[0.31 0.31 0.31]);
    set(handles.valS3, 'BackgroundColor',[0.31 0.31 0.31]);
    set(handles.valS4, 'BackgroundColor',[0.31 0.31 0.31]);
    set(handles.valS5, 'BackgroundColor',[0.31 0.31 0.31]);
    
    set(handles.muestrasEtiqueta, 'BackgroundColor',[0.31 0.31 0.31]);
    set(handles.numeroMuestras, 'BackgroundColor',[0.31 0.31 0.31]);    
    set(handles.etiquetaModelo, 'BackgroundColor',[0.31 0.31 0.31]);
    set(handles.modeloArduino, 'BackgroundColor',[0.31 0.31 0.31]);
    
    
end

% --- Executes on selection change in ListaDePuertos.
function ListaDePuertos_Callback(hObject, eventdata, handles)

function Lis_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function uipushtool3_ClickedCallback(hObject, eventdata, handles)




function popupmenu4_Callback(hObject, eventdata, handles)

function popupmenu4_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function pushbutton4_Callback(hObject, eventdata, handles)


function pushbutton3_Callback(hObject, eventdata, handles)

function pushbutton5_Callback(hObject, eventdata, handles)

function pushbutton6_Callback(hObject, eventdata, handles)


function popupmenu5_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function popupmenu5_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in finalizarConexionBoton.
function finalizarConexionBoton_Callback(hObject, eventdata, handles)



% --- Executes on selection change in seleccionCantidadSensores.
function seleccionCantidadSensores_Callback(hObject, eventdata, handles)
% hObject    handle to seleccionCantidadSensores (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns seleccionCantidadSensores contents as cell array
%        contents{get(hObject,'Value')} returns selected item from seleccionCantidadSensores


% --- Executes during object creation, after setting all properties.
function seleccionCantidadSensores_CreateFcn(hObject, eventdata, handles)
% hObject    handle to seleccionCantidadSensores (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in puertoSensor1.
function puertoSensor1_Callback(hObject, eventdata, handles)


function puertoSensor1_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function tipoSensor1_Callback(hObject, eventdata, handles)

function tipoSensor1_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in puertoSensor2.
function puertoSensor2_Callback(hObject, eventdata, handles)
% hObject    handle to puertoSensor2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns puertoSensor2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from puertoSensor2


% --- Executes during object creation, after setting all properties.
function puertoSensor2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to puertoSensor2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in tipoSensor2.
function tipoSensor2_Callback(hObject, eventdata, handles)
% hObject    handle to tipoSensor2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns tipoSensor2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from tipoSensor2


% --- Executes during object creation, after setting all properties.
function tipoSensor2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tipoSensor2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in puertoSensor3.
function puertoSensor3_Callback(hObject, eventdata, handles)
% hObject    handle to puertoSensor3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns puertoSensor3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from puertoSensor3


% --- Executes during object creation, after setting all properties.
function puertoSensor3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to puertoSensor3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in tipoSensor3.
function tipoSensor3_Callback(hObject, eventdata, handles)
% hObject    handle to tipoSensor3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns tipoSensor3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from tipoSensor3


% --- Executes during object creation, after setting all properties.
function tipoSensor3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tipoSensor3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in puertoSensor4.
function puertoSensor4_Callback(hObject, eventdata, handles)
% hObject    handle to puertoSensor4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns puertoSensor4 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from puertoSensor4


% --- Executes during object creation, after setting all properties.
function puertoSensor4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to puertoSensor4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in tipoSensor4.
function tipoSensor4_Callback(hObject, eventdata, handles)
% hObject    handle to tipoSensor4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns tipoSensor4 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from tipoSensor4


% --- Executes during object creation, after setting all properties.
function tipoSensor4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tipoSensor4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in puertoSensor5.
function puertoSensor5_Callback(hObject, eventdata, handles)
% hObject    handle to puertoSensor5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns puertoSensor5 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from puertoSensor5


% --- Executes during object creation, after setting all properties.
function puertoSensor5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to puertoSensor5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in tipoSensor5.
function tipoSensor5_Callback(hObject, eventdata, handles)
% hObject    handle to tipoSensor5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns tipoSensor5 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from tipoSensor5


% --- Executes during object creation, after setting all properties.
function tipoSensor5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tipoSensor5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in guardarNumeroSensoresBoton.
function guardarNumeroSensoresBoton_Callback(hObject, eventdata, handles)
global numeroSensores;
global listaDePuertos;
%desactivamos las listas de puertos y de tipos de sensores
set(handles.puertoSensor1, 'Enable', 'off');
set(handles.tipoSensor1, 'Enable', 'off');
set(handles.puertoSensor2, 'Enable', 'off');
set(handles.tipoSensor2, 'Enable', 'off');
set(handles.puertoSensor3, 'Enable', 'off');
set(handles.tipoSensor3, 'Enable', 'off');
set(handles.puertoSensor4, 'Enable', 'off');
set(handles.tipoSensor4, 'Enable', 'off');
set(handles.puertoSensor5, 'Enable', 'off');
set(handles.tipoSensor5, 'Enable', 'off');

cantidadSensores = get(handles.seleccionCantidadSensores,'Value');
numeroSensores = cantidadSensores;

%cargamos datos de tabla se sensores a la lista de sensores disponibles
load sensores.mat
for i = 1:1:size(sensores,1)
    textListaSensores(i) = sensores.Var1(i);
end

indice = 1;
for i = 1:1:size(listaDePuertos,2)
    temp = char(listaDePuertos(i));
    if isequal(temp(1),'A')
        textListaPuertos{indice} = temp;
        indice = indice + 1;
    end
end

set(handles.puertoSensor1, 'String', textListaPuertos);
set(handles.puertoSensor2, 'String', textListaPuertos);
set(handles.puertoSensor3, 'String', textListaPuertos);
set(handles.puertoSensor4, 'String', textListaPuertos);
set(handles.puertoSensor5, 'String', textListaPuertos);

%actualizamos los tipos de sensores disponibles para elegir
set(handles.tipoSensor1, 'String', textListaSensores);
set(handles.tipoSensor2, 'String', textListaSensores);
set(handles.tipoSensor3, 'String', textListaSensores);
set(handles.tipoSensor4, 'String', textListaSensores);
set(handles.tipoSensor5, 'String', textListaSensores);

set(handles.guardarEleccionSensores, 'Enable', 'on');
switch cantidadSensores
    
    case 1
        set(handles.puertoSensor1, 'Enable', 'on');
        set(handles.tipoSensor1, 'Enable', 'on');
        %configuramos la posicion y visibilidad de los planos cartesianos
        set(handles.grafico1, 'Position', [62, 10.154, 143, 37], 'Visible', 'on' );
        set(handles.grafico2,'Visible', 'off'  );
        set(handles.grafico3,'Visible', 'off'  );
        set(handles.grafico4,'Visible', 'off'  );
        set(handles.grafico5,'Visible', 'off'  );
        set(handles.nombreSensor1, 'Enable', 'on');
        
    case 2
        set(handles.puertoSensor1, 'Enable', 'on');
        set(handles.tipoSensor1, 'Enable', 'on');
        set(handles.puertoSensor2, 'Enable', 'on');
        set(handles.tipoSensor2, 'Enable', 'on');
        
        %configuramos la posicion y visibilidad de los planos cartesianos
        set(handles.grafico1, 'Position', [62, 29.692, 143, 17.5], 'Visible', 'on' );
        set(handles.grafico2, 'Position', [62, 10.154, 143, 17.5] , 'Visible', 'on'  );
        set(handles.grafico3,'Visible', 'off'  );
        set(handles.grafico4,'Visible', 'off'  );
        set(handles.grafico5,'Visible', 'off'  );
        set(handles.nombreSensor1, 'Enable', 'on');
        set(handles.nombreSensor2, 'Enable', 'on');
    case 3
        set(handles.puertoSensor1, 'Enable', 'on');
        set(handles.tipoSensor1, 'Enable', 'on');
        set(handles.puertoSensor2, 'Enable', 'on');
        set(handles.tipoSensor2, 'Enable', 'on');
        set(handles.puertoSensor3, 'Enable', 'on');
        set(handles.tipoSensor3, 'Enable', 'on');
        
        %configuramos la posicion y visibilidad de los planos cartesianos
        set(handles.grafico1, 'Position', [62, 35.846, 143, 11], 'Visible', 'on' );
        set(handles.grafico2, 'Position', [62, 23, 143, 11] , 'Visible', 'on'  );
        set(handles.grafico3, 'Position', [62, 10.154, 143, 11], 'Visible', 'on'  );
        set(handles.grafico4,'Visible', 'off'  );
        set(handles.grafico5,'Visible', 'off'  );
        
        set(handles.nombreSensor1, 'Enable', 'on');
        set(handles.nombreSensor2, 'Enable', 'on');
        set(handles.nombreSensor3, 'Enable', 'on');
        
    case 4
        set(handles.puertoSensor1, 'Enable', 'on');
        set(handles.tipoSensor1, 'Enable', 'on');
        set(handles.puertoSensor2, 'Enable', 'on');
        set(handles.tipoSensor2, 'Enable', 'on');
        set(handles.puertoSensor3, 'Enable', 'on');
        set(handles.tipoSensor3, 'Enable', 'on');
        set(handles.puertoSensor4, 'Enable', 'on');
        set(handles.tipoSensor4, 'Enable', 'on');
        
        %configuramos la posicion y visibilidad de los planos cartesianos
        set(handles.grafico1, 'Position', [62, 38.923, 143, 8.231], 'Visible', 'on' );
        set(handles.grafico2, 'Position', [62, 29.385, 143, 8.231] , 'Visible', 'on'  );
        set(handles.grafico3, 'Position', [62, 19.846, 143, 8.231], 'Visible', 'on'  );
        set(handles.grafico4, 'Position', [62, 10.231, 143, 8.231], 'Visible', 'on'  );
        set(handles.grafico5,'Visible', 'off'  );
        
        set(handles.nombreSensor1, 'Enable', 'on');
        set(handles.nombreSensor2, 'Enable', 'on');
        set(handles.nombreSensor3, 'Enable', 'on');
        set(handles.nombreSensor4, 'Enable', 'on');
    case 5
        set(handles.puertoSensor1, 'Enable', 'on');
        set(handles.tipoSensor1, 'Enable', 'on');
        set(handles.puertoSensor2, 'Enable', 'on');
        set(handles.tipoSensor2, 'Enable', 'on');
        set(handles.puertoSensor3, 'Enable', 'on');
        set(handles.tipoSensor3, 'Enable', 'on');
        set(handles.puertoSensor4, 'Enable', 'on');
        set(handles.tipoSensor4, 'Enable', 'on');
        set(handles.puertoSensor5, 'Enable', 'on');
        set(handles.tipoSensor5, 'Enable', 'on');
        
        %configuramos la posicion y visibilidad de los planos cartesianos
        set(handles.grafico1, 'Position', [62, 40.923, 143, 6.154], 'Visible', 'on' );
        set(handles.grafico2, 'Position', [62, 33.308, 143, 6.154] , 'Visible', 'on'  );
        set(handles.grafico3, 'Position', [62, 25.692, 143, 6.154], 'Visible', 'on'  );
        set(handles.grafico4, 'Position', [62, 18.077, 143, 6.154], 'Visible', 'on'  );
        set(handles.grafico5, 'Position', [62, 10.231, 143, 6.154], 'Visible', 'on'  );
        
        set(handles.nombreSensor1, 'Enable', 'on');
        set(handles.nombreSensor2, 'Enable', 'on');
        set(handles.nombreSensor3, 'Enable', 'on');
        set(handles.nombreSensor4, 'Enable', 'on');
        set(handles.nombreSensor5, 'Enable', 'on');
        
        
    otherwise
        set(handles.puertoSensor1, 'Enable', 'on');
        set(handles.tipoSensor1, 'Enable', 'on');
end
axes(handles.okPaso2);
im = imread('iconos\confirm.jpg');
image(im);
axis off;

%


% --- Executes on button press in guardarEleccionSensores.
function guardarEleccionSensores_Callback(hObject, eventdata, handles)
global N;
load sensores.mat

if isequal(get(handles.tipoSensor1,'Enable'), 'on')
    
    texto = get(handles.puertoSensor1, 'String');
    global puertoElegidoSensor1;
    puertoElegidoSensor1 = texto{get(handles.puertoSensor1, 'Value')};
    indiceTipoSensor1 = get(handles.tipoSensor1,'Value');
    global expresion1;
    expresion1 = char(sensores.Var2(indiceTipoSensor1));
    global nombreRealSensor1;
    nombreRealSensor1 = get(handles.nombreSensor1,'String');
    
    if comprobarNombreSensor(nombreRealSensor1, 'Sensor1') == 1
        nombreRealSensor1 = 'Sensor1';
        
    end
    
    global linea1;
    axes(handles.grafico1);
    linea1 = line(nan, nan,  'Color',   [0.6  0.6  0.6], 'LineWidth', 1.5);
    global unidadS1;
    unidadS1 = sensores.Var3(indiceTipoSensor1);
    ylabel(unidadS1,'FontWeight', 'bold', 'FontSize', 10 ) % y-axis label
    ylim([sensores.Var4(indiceTipoSensor1) sensores.Var5(indiceTipoSensor1)]);
    
    legend(linea1, nombreRealSensor1, 'Location','southwest');
    
    %configuramos la tabla:
    cabecerasColumnas = {'Tiempo [s]' nombreRealSensor1 };
    anchoColumnas = {200 200};
    set(handles.tablaDeDatos,'ColumnName', cabecerasColumnas, 'ColumnWidth', anchoColumnas);
    set(handles.indicarS1,'Enable', 'on');
    
end

if isequal(get(handles.tipoSensor2,'Enable'), 'on')
    
    texto = get(handles.puertoSensor2, 'String');
    global puertoElegidoSensor2;
    puertoElegidoSensor2 = texto{get(handles.puertoSensor2, 'Value')};
    
    indiceTipoSensor2 = get(handles.tipoSensor2,'Value');
    global expresion2;
    expresion2 = char(sensores.Var2(indiceTipoSensor2));
    
    global nombreRealSensor2;
    nombreRealSensor2 = get(handles.nombreSensor2,'String');
    
    if comprobarNombreSensor(nombreRealSensor2, 'Sensor2') == 1
        nombreRealSensor2 = 'Sensor2';
    end
    
    axes(handles.grafico2);
    global linea2;
    linea2 = line(nan, nan, 'Color',     [0.6  0.6  0.6], 'LineWidth', 1.5);
    global unidadS2;
    unidadS2 = sensores.Var3(indiceTipoSensor2);
    ylabel(unidadS2,'FontWeight', 'bold', 'FontSize', 10 ) % y-axis label
    ylim([sensores.Var4(indiceTipoSensor2) sensores.Var5(indiceTipoSensor2)]);
    legend(linea2, nombreRealSensor2, 'Location','southwest');
    
    %configuramos la tabla:
    cabecerasColumnas = {'Tiempo [s]' nombreRealSensor1 nombreRealSensor2 };
    anchoColumnas = {133 133 134};
    set(handles.tablaDeDatos,'ColumnName', cabecerasColumnas, 'ColumnWidth', anchoColumnas);
    set(handles.indicarS2,'Enable', 'on');
    
    
end

if isequal(get(handles.tipoSensor3,'Enable'), 'on')
    
    texto = get(handles.puertoSensor3, 'String');
    global puertoElegidoSensor3;
    
    puertoElegidoSensor3 = texto{get(handles.puertoSensor3, 'Value')};
    
    
    indiceTipoSensor3 = get(handles.tipoSensor3,'Value');
    global expresion3;
    expresion3 = char(sensores.Var2(indiceTipoSensor3));
    
    global nombreRealSensor3;
    nombreRealSensor3 = get(handles.nombreSensor3,'String');
    
    if comprobarNombreSensor(nombreRealSensor3, 'Sensor3') == 1
        nombreRealSensor3 = 'Sensor3';
        
    end
    
    global linea3;
    axes(handles.grafico3);
    linea3 = line(nan, nan, 'Color',       [0.6  0.6  0.6], 'LineWidth', 1.5);
    global unidadS3;
    unidadS3 = sensores.Var3(indiceTipoSensor1);
    ylabel(unidadS3,'FontWeight', 'bold', 'FontSize', 10 ) % y-axis label
    ylim([sensores.Var4(indiceTipoSensor3) sensores.Var5(indiceTipoSensor3)]);
    legend(linea3, nombreRealSensor3, 'Location','southwest');
    
    %configuramos la tabla:
    cabecerasColumnas = {'Tiempo [s]' nombreRealSensor1 nombreRealSensor2 nombreRealSensor3};
    anchoColumnas = {100 100 100 100};
    set(handles.tablaDeDatos,'ColumnName', cabecerasColumnas, 'ColumnWidth', anchoColumnas);
    set(handles.indicarS3,'Enable', 'on');
    
    
end

if isequal(get(handles.tipoSensor4,'Enable'), 'on')
    
    texto = get(handles.puertoSensor4, 'String');
    global puertoElegidoSensor4;
    puertoElegidoSensor4 = texto{get(handles.puertoSensor4, 'Value')};
    
    
    
    indiceTipoSensor4 = get(handles.tipoSensor4,'Value');
    global expresion4;
    expresion4 = char(sensores.Var2(indiceTipoSensor4));
    
    
    global nombreRealSensor4;
    nombreRealSensor4 = get(handles.nombreSensor4,'String');
    
    if comprobarNombreSensor(nombreRealSensor4, 'Sensor4') == 1
        nombreRealSensor4 = 'Sensor4';
        
    end
    
    
    global linea4;
    axes(handles.grafico4);
    linea4 = line(nan, nan, 'Color', [0.6  0.6  0.6], 'LineWidth', 1.5);
    global unidadS4;
    unidadS4 = sensores.Var3(indiceTipoSensor4);
    ylabel(unidadS4,'FontWeight', 'bold', 'FontSize', 10 ) % y-axis label
    ylim([sensores.Var4(indiceTipoSensor4) sensores.Var5(indiceTipoSensor4)]);
    legend(linea4, nombreRealSensor4, 'Location','southwest');
    
    %configuramos la tabla:
    cabecerasColumnas = {'Tiempo [s]' nombreRealSensor1 nombreRealSensor2 nombreRealSensor3 nombreRealSensor4 };
    anchoColumnas = {80  80 80 80};
    set(handles.tablaDeDatos,'ColumnName', cabecerasColumnas, 'ColumnWidth', anchoColumnas);
    set(handles.indicarS4,'Enable', 'on');
    
end

if isequal(get(handles.tipoSensor5,'Enable'), 'on')
    
    texto = get(handles.puertoSensor5, 'String');
    global puertoElegidoSensor5;
    puertoElegidoSensor5 = texto{get(handles.puertoSensor5, 'Value')};
    
    
    indiceTipoSensor5 = get(handles.tipoSensor5,'Value');
    global expresion5;
    expresion5 = char(sensores.Var2(indiceTipoSensor5));
    
    global nombreRealSensor5;
    nombreRealSensor5 = get(handles.nombreSensor5,'String');
    
    if comprobarNombreSensor(nombreRealSensor5, 'Sensor5') == 1
        nombreRealSensor5 = 'Sensor5';
        
    end
    
    
    
    global linea5;
    axes(handles.grafico5);
    linea5 = line(nan, nan, 'Color',   [0.6  0.6  0.6], 'LineWidth', 1.5);
    global unidadS5;
    unidadS5 = sensores.Var3(indiceTipoSensor1);
    ylabel(unidadS5,'FontWeight', 'bold', 'FontSize', 10 ) % y-axis label
    ylim([sensores.Var4(indiceTipoSensor5) sensores.Var5(indiceTipoSensor5)]);
    legend(linea5, nombreRealSensor5, 'Location','southwest');
    
    %configuramos la tabla:
    cabecerasColumnas = {'Tiempo [s]' nombreRealSensor1 nombreRealSensor2 nombreRealSensor3 nombreRealSensor4 nombreRealSensor5 };
    anchoColumnas = {67 67 67 67 66 66};
    set(handles.tablaDeDatos,'ColumnName', cabecerasColumnas, 'ColumnWidth', anchoColumnas);
    set(handles.indicarS5,'Enable', 'on');
    
end

set(handles.puertoSensor1, 'Enable', 'off');
set(handles.tipoSensor1, 'Enable', 'off');
set(handles.puertoSensor2, 'Enable', 'off');
set(handles.tipoSensor2, 'Enable', 'off');
set(handles.puertoSensor3, 'Enable', 'off');
set(handles.tipoSensor3, 'Enable', 'off');
set(handles.puertoSensor4, 'Enable', 'off');
set(handles.tipoSensor4, 'Enable', 'off');
set(handles.puertoSensor5, 'Enable', 'off');
set(handles.tipoSensor5, 'Enable', 'off');

set(handles.nombreSensor1,'Enable', 'off');
set(handles.nombreSensor2,'Enable', 'off');
set(handles.nombreSensor3,'Enable', 'off');
set(handles.nombreSensor4,'Enable', 'off');
set(handles.nombreSensor5,'Enable', 'off');

set(handles.seleccionCantidadSensores, 'Enable','off');
set(handles.guardarNumeroSensoresBoton, 'Enable','off');
set(handles.guardarEleccionSensores, 'Enable','off');
set(handles.anadirSensoresBoton, 'Enable', 'off');

set(handles.opcionPeriodo, 'Enable', 'on');
set(handles.valorOpcionPeriodo, 'Enable', 'on');
set(handles.opcionFrecuencia, 'Enable', 'on');
set(handles.guardarPeriodoBoton, 'Enable', 'on');



h = msgbox('Sensores Configurados Satisfactoriamente. A continuación asigne un valor de periodo o frecuencia de muestreo', 'Configuración Correcta');
uiwait;
axes(handles.okPaso3);
im = imread('iconos\confirm.jpg');
image(im);
axis off;






function valorOpcionFrecuencia_Callback(hObject, eventdata, handles)
axes(handles.okPaso4);
im = imread('iconos\no-confirm.jpg');
image(im);
axis off;


% --- Executes during object creation, after setting all properties.
function valorOpcionFrecuencia_CreateFcn(hObject, eventdata, handles)
% hObject    handle to valorOpcionFrecuencia (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in guardarPeriodoBoton.
function guardarPeriodoBoton_Callback(hObject, eventdata, handles)
global mostrandoDatos;
global periodoDeMuestreo;
global obteniendoDatos;
global tiempo;
global N;
global frecuenciaDeGraficado;
global capturandoDatos;

if isequal(get(handles.opcionPeriodo,'Value'),1) && isequal(get(handles.opcionFrecuencia,'Value'),0)
    if isequal(datoValido(get(handles.valorOpcionPeriodo,'String')),1)
        periodoDeMuestreo = str2double(get(handles.valorOpcionPeriodo,'String'));
        
        tiempo = linspace(0, (N-1)/frecuenciaDeGraficado, N);
        frecDeMuestreo = 1.0/periodoDeMuestreo;
        set(handles.valorOpcionFrecuencia, 'String',num2str(frecDeMuestreo));
        axes(handles.okPaso4);
        im = imread('iconos\confirm.jpg');
        image(im);
        axis off;
        set(handles.iniciarPararCapturaBoton, 'Enable','on');
        obteniendoDatos = true;
        mostrandoDatos = true;
    end
elseif isequal(get(handles.opcionPeriodo,'Value'),0) && isequal(get(handles.opcionFrecuencia,'Value'),1)
    if isequal(datoValido(get(handles.valorOpcionFrecuencia,'String')),1)
        frecDeMuestreo = str2double(get(handles.valorOpcionFrecuencia,'String'));
        periodoDeMuestreo = 1.0/frecDeMuestreo;
        
        tiempo = linspace(0, (N-1)/frecuenciaDeGraficado, N);
        set(handles.valorOpcionPeriodo, 'String',num2str(periodoDeMuestreo));
        axes(handles.okPaso4);
        imshow('confirm.gif');
        set(handles.iniciarPararCapturaBoton, 'Enable','on');
        obteniendoDatos = true;
        mostrandoDatos = true;
    end
end
global numeroSensores;
global vectorMediciones;
global arduinoPlaca;

global expresion1;
global expresion2
global expresion3;
global expresion4;
global expresion5;

global linea1;
global linea2;
global linea3;
global linea4,
global linea5;

global puertoElegidoSensor1;
global puertoElegidoSensor2;
global puertoElegidoSensor3;
global puertoElegidoSensor4;
global puertoElegidoSensor5;


if obteniendoDatos == true
    global variableTiempo;
    variableTiempo = 0;
    tiempoAcumulado = 0;
    indiceTabla = 1;
    switch (numeroSensores)
        case 1
            
            axes(handles.grafico1);
            xlim([0 (N-1)/frecuenciaDeGraficado ]);
            tic;
            y1 = zeros(N,1);
            
            while mostrandoDatos == true
                if toc > 1/frecuenciaDeGraficado
                    tiempoAcumulado = tiempoAcumulado + toc;
                    tic;
                    y1(1:end-1) = y1(2:end);
                    sensor1 = arduinoPlaca.readVoltage(puertoElegidoSensor1);
                    y1(end) = evaluar(expresion1,sensor1);
                    set(handles.valS1,'String', num2str(y1(end)));
                    set(linea1, 'XData', tiempo, 'YData', y1);
                    drawnow;
                    
                    if tiempoAcumulado >= periodoDeMuestreo
                        variableTiempo = variableTiempo + periodoDeMuestreo;
                        tiempoAcumulado = 0;
                        %escribir en la tabla
                        if capturandoDatos == true
                            MatrizDatos(indiceTabla,:) = {variableTiempo y1(end)};
                            set(handles.tablaDeDatos, 'Data',MatrizDatos);
                            set(handles.numeroMuestras, 'String', num2str(indiceTabla));
                            indiceTabla = indiceTabla +1;
                        end
                    end
                end
                
            end
            
        case 2
            
            axes(handles.grafico1);
            xlim([0 (N-1)/frecuenciaDeGraficado]);
            axes(handles.grafico2)
            xlim([0 (N-1)/frecuenciaDeGraficado]);
            tic;
            y1 = zeros(N,1);
            y2 = zeros(N,1);
            while mostrandoDatos == true
                if toc > 1/frecuenciaDeGraficado
                    tiempoAcumulado = tiempoAcumulado + toc;
                    tic;
                    y1(1:end-1) = y1(2:end);
                    y2(1:end-1) = y2(2:end);
                    sensor1 = arduinoPlaca.readVoltage(puertoElegidoSensor1);
                    sensor2 = arduinoPlaca.readVoltage(puertoElegidoSensor2);
                    y1(end) = evaluar(expresion1,sensor1);
                    y2(end) = evaluar(expresion2,sensor2);
                    set(handles.valS1,'String', num2str(y1(end)));
                    set(handles.valS2,'String', num2str(y2(end)));
                    axes(handles.grafico1);
                    set(linea1, 'XData', tiempo, 'YData', y1);
                    axes(handles.grafico2);
                    set(linea2, 'XData', tiempo, 'YData', y2);
                    drawnow;
                    
                    if tiempoAcumulado >= periodoDeMuestreo
                        variableTiempo = variableTiempo + periodoDeMuestreo;
                        tiempoAcumulado = 0;
                        %escribir en la tabla
                        if capturandoDatos == true
                            
                            MatrizDatos(indiceTabla,:) = {variableTiempo y1(end) y2(end)};
                            set(handles.tablaDeDatos, 'Data',MatrizDatos);
                            set(handles.numeroMuestras, 'String', num2str(indiceTabla));
                            indiceTabla = indiceTabla +1;
                        end
                    end
                    
                end
                
            end
            
        case 3
            
            axes(handles.grafico1);
            xlim([0 (N-1)/frecuenciaDeGraficado]);
            axes(handles.grafico2)
            xlim([0 (N-1)/frecuenciaDeGraficado]);
            axes(handles.grafico3)
            xlim([0 (N-1)/frecuenciaDeGraficado]);
            tic;
            
            y1 = zeros(N,1);
            y2 = zeros(N,1);
            y3 = zeros(N,1);
            while mostrandoDatos == true
                if toc > 1/frecuenciaDeGraficado
                    tiempoAcumulado = tiempoAcumulado + toc;
                    tic;
                    y1(1:end-1) = y1(2:end);
                    y2(1:end-1) = y2(2:end);
                    y3(1:end-1) = y3(2:end);
                    
                    sensor1 = arduinoPlaca.readVoltage(puertoElegidoSensor1);
                    sensor2 = arduinoPlaca.readVoltage(puertoElegidoSensor2);
                    sensor3 = arduinoPlaca.readVoltage(puertoElegidoSensor3);
                    
                    y1(end) = evaluar(expresion1,sensor1);
                    y2(end) = evaluar(expresion2,sensor2);
                    y3(end) = evaluar(expresion3,sensor3);
                    set(handles.valS1,'String', num2str(y1(end)));
                    set(handles.valS2,'String', num2str(y2(end)));
                    set(handles.valS3,'String', num2str(y3(end)));
                    
                    
                    axes(handles.grafico1);
                    set(linea1, 'XData', tiempo, 'YData', y1);
                    axes(handles.grafico2);
                    set(linea2, 'XData', tiempo, 'YData', y2);
                    axes(handles.grafico3);
                    set(linea3, 'XData', tiempo, 'YData', y3);
                    
                    drawnow;
                    
                    if tiempoAcumulado >= periodoDeMuestreo
                        variableTiempo = variableTiempo + periodoDeMuestreo;
                        tiempoAcumulado = 0;
                        %escribir en la tabla
                        if capturandoDatos == true
                            MatrizDatos(indiceTabla,:) = {variableTiempo y1(end) y2(end) y3(end)};
                            set(handles.tablaDeDatos, 'Data',MatrizDatos);
                            
                            set(handles.numeroMuestras, 'String', num2str(indiceTabla));
                            indiceTabla = indiceTabla +1;
                        end
                    end
                    
                end
                
            end
            
        case 4
            
            axes(handles.grafico1);
            xlim([0 (N-1)/frecuenciaDeGraficado]);
            axes(handles.grafico2)
            xlim([0 (N-1)/frecuenciaDeGraficado]);
            axes(handles.grafico3)
            xlim([0 (N-1)/frecuenciaDeGraficado]);
            axes(handles.grafico4)
            xlim([0 (N-1)/frecuenciaDeGraficado]);
            tic;
            
            y1 = zeros(N,1);
            y2 = zeros(N,1);
            y3 = zeros(N,1);
            y4 = zeros(N,1);
            
            while mostrandoDatos == true
                if toc > 1/frecuenciaDeGraficado
                    tiempoAcumulado = tiempoAcumulado + toc;
                    tic;
                    y1(1:end-1) = y1(2:end);
                    y2(1:end-1) = y2(2:end);
                    y3(1:end-1) = y3(2:end);
                    y4(1:end-1) = y4(2:end);
                    
                    sensor1 = arduinoPlaca.readVoltage(puertoElegidoSensor1);
                    sensor2 = arduinoPlaca.readVoltage(puertoElegidoSensor2);
                    sensor3 = arduinoPlaca.readVoltage(puertoElegidoSensor3);
                    sensor4 = arduinoPlaca.readVoltage(puertoElegidoSensor4);
                    
                    y1(end) = evaluar(expresion1,sensor1);
                    y2(end) = evaluar(expresion2,sensor2);
                    y3(end) = evaluar(expresion3,sensor3);
                    y4(end) = evaluar(expresion3,sensor4);
                    set(handles.valS1,'String', num2str(y1(end)));
                    set(handles.valS2,'String', num2str(y2(end)));
                    set(handles.valS3,'String', num2str(y3(end)));
                    set(handles.valS4,'String', num2str(y4(end)));
                    
                    axes(handles.grafico1);
                    set(linea1, 'XData', tiempo, 'YData', y1);
                    axes(handles.grafico2);
                    set(linea2, 'XData', tiempo, 'YData', y2);
                    axes(handles.grafico3);
                    set(linea3, 'XData', tiempo, 'YData', y3);
                    axes(handles.grafico4);
                    set(linea4, 'XData', tiempo, 'YData', y4);
                    
                    drawnow;
                    
                    if tiempoAcumulado >= periodoDeMuestreo
                        tiempoAcumulado = 0;
                        variableTiempo = variableTiempo + periodoDeMuestreo;
                        %escribir en la tabla
                        
                        if capturandoDatos == true
                            MatrizDatos(indiceTabla,:) = {variableTiempo y1(end) y2(end) y3(end) y4(end)};
                            set(handles.tablaDeDatos, 'Data',MatrizDatos);
                            
                            set(handles.numeroMuestras, 'String', num2str(indiceTabla));
                            indiceTabla = indiceTabla +1;
                        end
                    end
                    
                end
                
            end
            
        case 5
            
            axes(handles.grafico1);
            xlim([0 (N-1)/frecuenciaDeGraficado]);
            axes(handles.grafico2)
            xlim([0 (N-1)/frecuenciaDeGraficado]);
            axes(handles.grafico3)
            xlim([0 (N-1)/frecuenciaDeGraficado]);
            axes(handles.grafico4)
            xlim([0 (N-1)/frecuenciaDeGraficado]);
            axes(handles.grafico5)
            xlim([0 (N-1)/frecuenciaDeGraficado]);
            tic;
            
            y1 = zeros(N,1);
            y2 = zeros(N,1);
            y3 = zeros(N,1);
            y4 = zeros(N,1);
            y5 = zeros(N,1);
            
            while mostrandoDatos == true
                
                if toc > 1/frecuenciaDeGraficado
                    tiempoAcumulado = tiempoAcumulado + toc;
                    tic;
                    y1(1:end-1) = y1(2:end);
                    y2(1:end-1) = y2(2:end);
                    y3(1:end-1) = y3(2:end);
                    y4(1:end-1) = y4(2:end);
                    y5(1:end-1) = y5(2:end);
                    
                    sensor1 = arduinoPlaca.readVoltage(puertoElegidoSensor1);
                    sensor2 = arduinoPlaca.readVoltage(puertoElegidoSensor2);
                    sensor3 = arduinoPlaca.readVoltage(puertoElegidoSensor3);
                    sensor4 = arduinoPlaca.readVoltage(puertoElegidoSensor4);
                    sensor5 = arduinoPlaca.readVoltage(puertoElegidoSensor5);
                    
                    y1(end) = evaluar(expresion1,sensor1);
                    y2(end) = evaluar(expresion2,sensor2);
                    y3(end) = evaluar(expresion3,sensor3);
                    y4(end) = evaluar(expresion4,sensor4);
                    y5(end) = evaluar(expresion5,sensor5);
                    
                    set(handles.valS1,'String', num2str(y1(end)));
                    set(handles.valS2,'String', num2str(y2(end)));
                    set(handles.valS3,'String', num2str(y3(end)));
                    set(handles.valS4,'String', num2str(y4(end)));
                    set(handles.valS5,'String', num2str(y5(end)));
                    
                    axes(handles.grafico1);
                    set(linea1, 'XData', tiempo, 'YData', y1);
                    axes(handles.grafico2);
                    set(linea2, 'XData', tiempo, 'YData', y2);
                    axes(handles.grafico3);
                    set(linea3, 'XData', tiempo, 'YData', y3);
                    axes(handles.grafico4);
                    set(linea4, 'XData', tiempo, 'YData', y4);
                    axes(handles.grafico5);
                    set(linea5, 'XData', tiempo, 'YData', y5);
                    drawnow;
                    
                    if tiempoAcumulado >= periodoDeMuestreo
                        variableTiempo = variableTiempo + periodoDeMuestreo;
                        tiempoAcumulado = 0;
                        
                        %escribir en la tabla
                        if capturandoDatos == true
                            MatrizDatos(indiceTabla,:) = {variableTiempo y1(end) y2(end) y3(end) y4(end) y5(end)};
                            set(handles.tablaDeDatos, 'Data',MatrizDatos);
                            set(handles.numeroMuestras, 'String', num2str(indiceTabla));
                            indiceTabla = indiceTabla +1;
                        end
                        
                    end
                    
                end
                
            end
    end
end






% --- Executes on button press in guardarDatosBoton.
function guardarDatosBoton_Callback(hObject, eventdata, handles)

global mostrandoDatos;
global capturandoDatos;
global obteniendoDatos;
capturandoDatos = false;
obteniendoDatos = false;
mostrandoDatos = false;

if capturandoDatos == true
    capturandoDatos = false;
    switch numeroSensores
        case 1
            set(linea1, 'Color', [0.6 0.6 0.6]);
        case 2
            set(linea1, 'Color', [0.6 0.6 0.6]);
            set(linea2, 'Color', [0.6 0.6 0.6]);
        case 3
            set(linea1, 'Color', [0.6 0.6 0.6]);
            set(linea2, 'Color', [0.6 0.6 0.6]);
            set(linea3, 'Color', [0.6 0.6 0.6]);
        case 4
            set(linea1, 'Color', [0.6 0.6 0.6]);
            set(linea2, 'Color', [0.6 0.6 0.6]);
            set(linea3, 'Color', [0.6 0.6 0.6]);
            set(linea4, 'Color', [0.6 0.6 0.6]);
        case 5
            set(linea1, 'Color', [0.6 0.6 0.6]);
            set(linea2, 'Color', [0.6 0.6 0.6]);
            set(linea3, 'Color', [0.6 0.6 0.6]);
            set(linea4, 'Color', [0.6 0.6 0.6]);
            set(linea5, 'Color', [0.6 0.6 0.6]);
            
            
    end
    
    set(handles.iniciarPararCapturaBoton,'String','Iniciar Captura De Datos', 'ForegroundColor', [0 0.498 0]);
end


%iniciarPararCapturaBoton_Callback(handles.iniciarPararCapturaBoton, eventdata, handles)




get(handles.tablaDeDatos,'Data');

DatosDeTabla = [get(handles.tablaDeDatos,'ColumnName')'; get(handles.tablaDeDatos,'Data')];

[arch, ruta] = uiputfile('*.xls', 'Guardar');
cadenaRuta = [ruta, arch];

if isequal(arch,0) || isequal(ruta,0)
    arch = 'Datos';
else
    xlswrite(cadenaRuta,DatosDeTabla);
end

% --- Executes on button press in pausarCapturaBoton.
function pausarCapturaBoton_Callback(hObject, eventdata, handles)
% hObject    handle to pausarCapturaBoton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in iniciarPararCapturaBoton.
function iniciarPararCapturaBoton_Callback(hObject, eventdata, handles)
global mostrandoDatos;
global capturandoDatos;
global numeroSensores;
global primeraCaptura;
global variableTiempo;
global linea1;
global linea2;
global linea3;
global linea4;
global linea5;

if primeraCaptura == false
    primeraCaptura = true;
    variableTiempo = 0;
end


if capturandoDatos == true
    capturandoDatos = false;
    switch numeroSensores
        case 1
            set(linea1, 'Color', [0.6 0.6 0.6]);
        case 2
            set(linea1, 'Color', [0.6 0.6 0.6]);
            set(linea2, 'Color', [0.6 0.6 0.6]);
        case 3
            set(linea1, 'Color', [0.6 0.6 0.6]);
            set(linea2, 'Color', [0.6 0.6 0.6]);
            set(linea3, 'Color', [0.6 0.6 0.6]);
        case 4
            set(linea1, 'Color', [0.6 0.6 0.6]);
            set(linea2, 'Color', [0.6 0.6 0.6]);
            set(linea3, 'Color', [0.6 0.6 0.6]);
            set(linea4, 'Color', [0.6 0.6 0.6]);
        case 5
            set(linea1, 'Color', [0.6 0.6 0.6]);
            set(linea2, 'Color', [0.6 0.6 0.6]);
            set(linea3, 'Color', [0.6 0.6 0.6]);
            set(linea4, 'Color', [0.6 0.6 0.6]);
            set(linea5, 'Color', [0.6 0.6 0.6]);
            
            
    end
    
    set(handles.iniciarPararCapturaBoton,'String','Iniciar Captura De Datos', 'ForegroundColor', [0 0.498 0]);
    
    set(handles.barraDeEstado, 'BackgroundColor',[0.31 0.31 0.31]);
    set(handles.indicarS1, 'BackgroundColor',[0.31 0.31 0.31]);
    set(handles.indicarS2, 'BackgroundColor',[0.31 0.31 0.31]);
    set(handles.indicarS3, 'BackgroundColor',[0.31 0.31 0.31]);
    set(handles.indicarS4, 'BackgroundColor',[0.31 0.31 0.31]);
    set(handles.indicarS5, 'BackgroundColor',[0.31 0.31 0.31]);
    
    set(handles.valS1, 'BackgroundColor',[0.31 0.31 0.31]);
    set(handles.valS2, 'BackgroundColor',[0.31 0.31 0.31]);
    set(handles.valS3, 'BackgroundColor',[0.31 0.31 0.31]);
    set(handles.valS4, 'BackgroundColor',[0.31 0.31 0.31]);
    set(handles.valS5, 'BackgroundColor',[0.31 0.31 0.31]);
    
    set(handles.muestrasEtiqueta, 'BackgroundColor',[0.31 0.31 0.31]);
    set(handles.numeroMuestras, 'BackgroundColor',[0.31 0.31 0.31]);
    set(handles.separador1, 'BackgroundColor',[0.31 0.31 0.31]);
    set(handles.separador2, 'BackgroundColor',[0.31 0.31 0.31]);
    set(handles.etiquetaModelo, 'BackgroundColor',[0.31 0.31 0.31]);
    set(handles.modeloArduino, 'BackgroundColor',[0.31 0.31 0.31]);
    
    
elseif capturandoDatos == false
    capturandoDatos = true;
    mostrandoDatos = true;
    set(handles.iniciarPararCapturaBoton,'String','Pausar/Detener Captura De Datos', 'ForegroundColor', 'r');
    set(handles.tablaDeDatos,'Enable', 'on');
    set(handles.muestrasEtiqueta, 'Enable', 'on');
    set(handles.guardarDatosBoton, 'Enable', 'on');
    switch numeroSensores
        case 1
            set(linea1, 'Color', [0.000  0.447  0.741]);
        case 2
            set(linea1, 'Color', [0.000  0.447  0.741]);
            set(linea2, 'Color', [0.850  0.325  0.098]);
        case 3
            set(linea1, 'Color', [0.000  0.447  0.741]);
            set(linea2, 'Color', [0.850  0.325  0.098]);
            set(linea3, 'Color', [0.494  0.184  0.556]);
        case 4
            set(linea1, 'Color', [0.000  0.447  0.741]);
            set(linea2, 'Color', [0.850  0.325  0.098]);
            set(linea3, 'Color', [0.494  0.184  0.556]);
            set(linea4, 'Color', [0.466  0.674  0.188]);
        case 5
            set(linea1, 'Color', [0.000  0.447  0.741]);
            set(linea2, 'Color', [0.850  0.325  0.098]);
            set(linea3, 'Color', [0.494  0.184  0.556]);
            set(linea4, 'Color', [0.466  0.674  0.188]);
            set(linea5, 'Color', [0.635  0.078  0.184]);
            
    end
    
    set(handles.barraDeEstado, 'BackgroundColor',[0 0.5 0]);
    
    set(handles.indicarS1, 'BackgroundColor',[0 0.5 0]);
    set(handles.indicarS2, 'BackgroundColor',[0 0.5 0]);
    set(handles.indicarS3, 'BackgroundColor',[0 0.5 0]);
    set(handles.indicarS4, 'BackgroundColor',[0 0.5 0]);
    set(handles.indicarS5, 'BackgroundColor',[0 0.5 0]);
    
    set(handles.valS1, 'BackgroundColor',[0 0.5 0]);
    set(handles.valS2, 'BackgroundColor',[0 0.5 0]);
    set(handles.valS3, 'BackgroundColor',[0 0.5 0]);
    set(handles.valS4, 'BackgroundColor',[0 0.5 0]);
    set(handles.valS5, 'BackgroundColor',[0 0.5 0]);
    set(handles.muestrasEtiqueta, 'BackgroundColor',[0 0.5 0]);
    set(handles.numeroMuestras, 'BackgroundColor',[0 0.5 0]);
    set(handles.separador1, 'BackgroundColor',[0 0.5 0]);
    set(handles.separador2, 'BackgroundColor',[0 0.5 0]);
    set(handles.etiquetaModelo, 'BackgroundColor',[0 0.5 0]);
    set(handles.modeloArduino, 'BackgroundColor',[0 0.5 0]);
    
end


function valorOpcionPeriodo_Callback(hObject, eventdata, handles)
axes(handles.okPaso4);
im = imread('iconos\no-confirm.jpg');
image(im);
axis off;


% --- Executes during object creation, after setting all properties.
function valorOpcionPeriodo_CreateFcn(hObject, eventdata, handles)
% hObject    handle to valorOpcionPeriodo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in opcionPeriodo.
function opcionPeriodo_Callback(hObject, eventdata, handles)
set(handles.valorOpcionPeriodo,'Enable', 'on','String', '');
set(handles.valorOpcionFrecuencia,'Enable', 'off','String', '');
axes(handles.okPaso4);
im = imread('iconos\no-confirm.jpg');
image(im);
axis off;


% --- Executes on button press in opcionFrecuencia.
function opcionFrecuencia_Callback(hObject, eventdata, handles)
set(handles.valorOpcionPeriodo,'Enable', 'off','String', '');
set(handles.valorOpcionFrecuencia,'Enable', 'on','String', '' );
axes(handles.okPaso4);
im = imread('iconos\no-confirm.jpg');
image(im);
axis off;


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over iniciarPararCapturaBoton.
function iniciarPararCapturaBoton_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to iniciarPararCapturaBoton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in popupmenu18.
function popupmenu18_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu18 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu18


% --- Executes during object creation, after setting all properties.
function popupmenu18_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in nombreSensor5.
function nombreSensor5_Callback(hObject, eventdata, handles)
% hObject    handle to nombreSensor5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns nombreSensor5 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from nombreSensor5


% --- Executes during object creation, after setting all properties.
function nombreSensor5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nombreSensor5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in nombreSensor4.
function nombreSensor4_Callback(hObject, eventdata, handles)
% hObject    handle to nombreSensor4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns nombreSensor4 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from nombreSensor4


% --- Executes during object creation, after setting all properties.
function nombreSensor4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nombreSensor4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in nombreSensor3.
function nombreSensor3_Callback(hObject, eventdata, handles)
% hObject    handle to nombreSensor3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns nombreSensor3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from nombreSensor3


% --- Executes during object creation, after setting all properties.
function nombreSensor3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nombreSensor3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in nombreSensor2.
function nombreSensor2_Callback(hObject, eventdata, handles)
% hObject    handle to nombreSensor2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns nombreSensor2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from nombreSensor2


% --- Executes during object creation, after setting all properties.
function nombreSensor2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nombreSensor2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in nombreSensor1.
function nombreSensor1_Callback(hObject, eventdata, handles)
% hObject    handle to nombreSensor1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns nombreSensor1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from nombreSensor1


% --- Executes during object creation, after setting all properties.
function nombreSensor1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nombreSensor1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to nombreSensor1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of nombreSensor1 as text
%        str2double(get(hObject,'String')) returns contents of nombreSensor1 as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nombreSensor1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to nombreSensor2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of nombreSensor2 as text
%        str2double(get(hObject,'String')) returns contents of nombreSensor2 as a double


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nombreSensor2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to nombreSensor3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of nombreSensor3 as text
%        str2double(get(hObject,'String')) returns contents of nombreSensor3 as a double


% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nombreSensor3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to nombreSensor4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of nombreSensor4 as text
%        str2double(get(hObject,'String')) returns contents of nombreSensor4 as a double


% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nombreSensor4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit9_Callback(hObject, eventdata, handles)
% hObject    handle to nombreSensor5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of nombreSensor5 as text
%        str2double(get(hObject,'String')) returns contents of nombreSensor5 as a double


% --- Executes during object creation, after setting all properties.
function edit9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nombreSensor5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listaPlacas.
function listaPlacas_Callback(hObject, eventdata, handles)
% hObject    handle to listaPlacas (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listaPlacas contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listaPlacas


% --- Executes during object creation, after setting all properties.
function listaPlacas_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listaPlacas (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in anadirSensoresBoton.
function anadirSensoresBoton_Callback(hObject, eventdata, handles)
run anadirSensores;
uiwait;
guardarNumeroSensoresBoton_Callback(handles.guardarNumeroSensoresBoton, eventdata,handles);


% --- Executes when user attempts to close principal.
function principal_CloseRequestFcn(hObject, eventdata, handles)

global obteniendoDatos;
global capturandoDatos;
obteniendoDatos = false;
capturandoDatos = false;
delete(hObject);


% --------------------------------------------------------------------
function menuDatos_Callback(hObject, eventdata, handles)
% hObject    handle to menuDatos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menuGrafico_Callback(hObject, eventdata, handles)
% hObject    handle to menuGrafico (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menuAyuda_Callback(hObject, eventdata, handles)
% hObject    handle to menuAyuda (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function subMenuAcercaDe_Callback(hObject, eventdata, handles)
run Acerca;


% --------------------------------------------------------------------
function subMenuGuardarDatos_Callback(hObject, eventdata, handles)
% hObject    handle to subMenuGuardarDatos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function subMenuBorrarDatos_Callback(hObject, eventdata, handles)
% hObject    handle to subMenuBorrarDatos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function subMenuColoresGraficos_Callback(hObject, eventdata, handles)
% hObject    handle to subMenuColoresGraficos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function subMenuPropGraficos_Callback(hObject, eventdata, handles)
global mostrandoDatos;
run configuracionGraficos;

if mostrandoDatos == true
    guardarPeriodoBoton_Callback(handles.guardarPeriodoBoton, eventdata, handles);
end

% --------------------------------------------------------------------
function menuArchivo_Callback(hObject, eventdata, handles)
% hObject    handle to menuArchivo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function subMenuCerrar_Callback(hObject, eventdata, handles)

global obteniendoDatos;
global capturandoDatos;
global mostrandoDatos;
mostrandoDatos = false;
obteniendoDatos = false;
capturandoDatos = false;
close;


% --------------------------------------------------------------------
function menuSensores_Callback(hObject, eventdata, handles)
% hObject    handle to menuSensores (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function subMenuEditarSensores_Callback(hObject, eventdata, handles)
run anadirSensores;


% --- Executes on button press in instalarPaqueteBoton.
function instalarPaqueteBoton_Callback(hObject, eventdata, handles)

uiopen('arduino.mlpkginstall',1);
close;
