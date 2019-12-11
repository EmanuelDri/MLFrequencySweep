function main
[fileName,filePath]=uiputfile('*.mat','Seleccione archivo de respaldo');

fileAddress=fullfile(filePath,fileName);
cd(filePath);
responseChannel=input('Seleccione canal para la respuesta del filtro: ');

[sweepData]=frequencySweep(fileAddress,responseChannel);
[f,amps]=amplitudeCalculi(sweepData);
generateBode(f,amps);
end