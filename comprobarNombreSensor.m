function respuesta = comprobarNombreSensor(texto, sensor)

if isempty(texto)
    mensaje = ['No se asiganado un nombre al ', sensor,'.',' Se establecer� un nombre gen�rico'];
    h = msgbox(mensaje, 'Atenci�n');
    respuesta = true;
    uiwait;
    return;
else
    respuesta = false;
    return;
end

