function portlist = escanearPuertos(portlimit)


if ~isempty(instrfind)
    fclose(instrfind);
    delete(instrfind);
end

if nargin < 1
    portlimit = 15;
end
portlist = cell(0);

h = waitbar(0,'Escaneando Puertos Serial...','Name','Puertos Serial Disponibles...');
for i = 1:portlimit
    eval(['s = serial(''COM',num2str(i),''');']);
    try
        fopen(s);
        fclose(s);
        delete(s);
        portlist{end+1,1}=['COM',num2str(i)];
        waitbar(i/portlimit,h,['Encontrado ',num2str(numel(portlist)),' Puertos COM...']);
    catch
        delete(s);
        waitbar(i/portlimit,h);
    end
end
close(h);