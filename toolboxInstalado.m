function resultado = toolboxInstalado()
    ToolboxInstalados = matlabshared.supportpkg.getInstalled;
    resultado = false;

    for x = 1:1:size(ToolboxInstalados,2)
        if strcmp(ToolboxInstalados(x).Name,'Arduino') && strcmp(ToolboxInstalados(x).BaseProduct, 'MATLAB')
            resultado = true;
            return;
        end
    end
end

