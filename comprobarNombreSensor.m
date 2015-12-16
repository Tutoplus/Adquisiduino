function respuesta = comprobarNombreSensor(texto, sensor)

if isempty(texto)
    mensaje = ['No se asiganado un nombre al ', sensor,'.',' Se establecerá un nombre genérico'];
    h = msgbox(mensaje, 'Atención');
    respuesta = true;
    uiwait;
    return;
else
    respuesta = false;
    return;
end

