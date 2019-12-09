function main
[fileName,filePath]=uigetfile('*.mat','Seleccione archivo de respaldo', ...
    'MultiSelect', 'off');
fileAddress=fullfile(filePath,fileName);
cd(fileAddress);
responseChannel=input('Seleccione canal para la respuesta del filtro');
[sweepData]=frequencySweep(fileAddress,responseChannel);
[f,amps]=dynamicsCalculi(sweepData);
generateBode(f,amps);
end