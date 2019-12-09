function [resultados]=frequencySweep(nombreArchivo,responseChannel)
resultados=cell(0,5);
delete(instrfind);
oscilloscopeHandler=connectTektronixOscilloscope();
deviceObj=oscilloscopeHandler;
switch responseChannel
    case 1
        inputChannel=1;
    case 2 
        inputChannel=2;
    otherwise
        inputChannel=2;
end
% set(deviceObj.Measurement(inputChannel), 'MeasurementType', 'frequency');
% set(deviceObj.Measurement(inputChannel), 'Source', 'channel2');
% measuredFrequency = get(deviceObj.Measurement(inputChannel), 'Value');
adjustChannel(inputChannel,oscilloscopeHandler);
adjustChannel(responseChannel,oscilloscopeHandler);

frecuencia=input('frecuencia: ');
while ~isempty(frecuencia)
    period=1/frecuencia;
    timeBase=3.2*period/10;
    set(deviceObj.Acquisition, 'Timebase', timeBase);
    adjustChannel(inputChannel,oscilloscopeHandler);
    adjustChannel(responseChannel,oscilloscopeHandler);
    set(oscilloscopeHandler.Acquisition(responseChannel), 'Control', 'run-stop');
    set(oscilloscopeHandler.Acquisition(responseChannel), 'State', 'run');
    set(oscilloscopeHandler.Acquisition(responseChannel), 'Control', 'single');
    while strcmp(get(oscilloscopeHandler.Acquisition(responseChannel), 'State'),'run')
    end
    [xch1,ych1]=readOscilloscopeChannel(responseChannel,oscilloscopeHandler);
    [xch2,ych2]=readOscilloscopeChannel(inputChannel,oscilloscopeHandler);
    disp('Datos capturados ?');
    resultados(end+1,:)={xch1;ych1;xch2;ych2;frecuencia};
    set(oscilloscopeHandler.Acquisition(responseChannel), 'Control', 'run-stop');
    set(oscilloscopeHandler.Acquisition(responseChannel), 'State', 'run');
    sound(rand(responseChannel,200));
    frecuencia=input('frecuencia: ');
end
% nombreArchivo=input('Nombre del archivo: ','s');
save([nombreArchivo '.mat'],'resultados');
disp(['Datos guardados en archivo ' nombreArchivo '.mat']);
sound(rand(1,512));
set(oscilloscopeHandler.Acquisition(responseChannel), 'Control', 'run-stop');
set(oscilloscopeHandler.Acquisition(responseChannel), 'State', 'run');

    function adjustChannel(channelNumber,oscilloscopeHandler)
        goToVoltage(0,channelNumber,1);
        [~,amplitudes]=readOscilloscopeChannel(channelNumber,oscilloscopeHandler);
        setAmplitude=max(amplitudes)-min(amplitudes);
        if setAmplitude<1
            goToVoltage(0,channelNumber,.13);
            [~,amplitudes]=readOscilloscopeChannel(channelNumber,oscilloscopeHandler);
            setAmplitude=max(amplitudes)-min(amplitudes);
        end
        setOffset=(max(amplitudes)+min(amplitudes))/2;
        goToVoltage(setOffset,channelNumber,setAmplitude/7.5);
    end

end
