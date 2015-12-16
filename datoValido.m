function respuesta = datoValido(texto)
if isnan(str2double(texto))
   h= msgbox('El valor ingresado no es un número. Por favor ingrese un valor correcto', 'Valor no permitido');
   respuesta = false;
   return;
else
    if str2double(texto) > 108000
    h= msgbox('El valor ingresado es muy elevado. Por favor ingrese otro valor.', 'Valor no permitido');    
    respuesta = false;
    return;
    elseif str2double(texto) <= 0
        h= msgbox('El valor ingresado no puede ser menor o igual a 0. Por favor ingrese otro valor.', 'Valor no permitido');    
        respuesta = false;
    else
        respuesta = true;
    end
end
end

