# Adquisiduino
Adquisición de Datos en tiempo real con Arduino y MATLAB
## ¿Qué es Adquisiduino?
Adqusiduino es un software con interfaz gráfica dentro de MATLAB orientado exclusivamente a la adquisición de datos de sensores analógicos compatibles con Arduino u otras placas basadas en ésta. Capture datos de hasta 5 sensores analógicos en simultáneo y exporte los datos a una hoja de cálculo de Microsoft Excel.

![](https://48aeff32f14f2c88c2bc19f184a395e2d6883e32-www.googledrive.com/host/0B0DSdioGBbxZeGE2d0R5ZUhzVlE)
##Flexibilidad
###Añada y configure sus propios sensores analógicos
Adquisiduino le permite añadir, configurar y guardar sus propios sensores analógicos, ya sea porque se conoce la relación entre el parámetro que se desea medir y el voltaje leído en el pin analógico de arduino, o, por una función propia del usuario definida a nivel local en el entorno de MATLAB, la cual devuelve el valor de la medición en función de la entrada del sensor.

<p align="center">
    <img src="https://3a091ec4752eec74d6c0536c4567058567c041b4-www.googledrive.com/host/0B0DSdioGBbxZWGxELVFGUW1LNnc">
</p>
###Configure la representación gráfica
Adquisiduino, le permite configurar la frecuencia con la que los datos provenientes de arduino se representan en el área gráfica. Además, también es posible establecer un dominio visible de los datos en un período de tiempo. Ésta herramienta le permitirá escoger un período de muestreo apropiado.

## Dependencias
 1. Paquete de soporte de MATLAB para Arduino: [Descargar][1]

  [1]: http://www.mathworks.com/hardware-support/arduino-matlab.html?refresh=true
## Ejecución

 1. Descargue el **código fuente de Adquisiduino** y descomprima el contenido en una carpeta en el PC.
 2. En **MATLAB**, elija como **carpeta de trabajo** el directorio creado anteriormente.
 3. En el **Command Window** de MATLAB, tipee el siguiente comando:
`ejecutar`

##Compatibilidad
Por ahora, Adquisiduino solo está soportado por **MATLAB para Windows**.
