function [resultados]=frequencySweep(nombreArchivo,responseChannel)
resultados=cell(0,5);
delete(instrfind);
oscilloscopeHandler=connectTektronixOscilloscope();
deviceObj=oscilloscopeHandler;
switch responseChannel
    case 1
        inputChannel=2;
    case 2
        inputChannel=1;
    otherwise
        inputChannel=2;
end
% set(deviceObj.Measurement(inputChannel), 'MeasurementType', 'frequency');
% set(deviceObj.Measurement(inputChannel), 'Source', 'channel2');
% measuredFrequency = get(deviceObj.Measurement(inputChannel), 'Value');

set(deviceObj.Measurement(inputChannel), 'MeasurementType', 'frequency');
adjustChannel(inputChannel,oscilloscopeHandler);
adjustChannel(responseChannel,oscilloscopeHandler);

frecuencia=input('Configure una frecuencia y presione Enter o deje en blanco para salir: ');
% medir=~contains(entrada,'n');
medir=~isempty(frecuencia);
setFrecuency(oscilloscopeHandler,10);
while medir
%     waitSingleCapture(oscilloscopeHandler);
%     frecuencia = get(deviceObj.Measurement(1), 'Value');
    setFrecuency(oscilloscopeHandler,frecuencia)
%     adjustChannel(inputChannel,oscilloscopeHandler);
    adjustChannel(responseChannel,oscilloscopeHandler);
    for index=1:3
        waitSingleCapture(oscilloscopeHandler);
        [xch1,ych1]=readOscilloscopeChannel(responseChannel,oscilloscopeHandler);
        [xch2,ych2]=readOscilloscopeChannel(inputChannel,oscilloscopeHandler);
        disp('Datos capturados ?');
        resultados(end+1,:)={xch1;ych1;xch2;ych2;frecuencia};
        set(oscilloscopeHandler.Acquisition(responseChannel), 'Control', 'run-stop');
        set(oscilloscopeHandler.Acquisition(responseChannel), 'State', 'run');
    end
    sound(rand(1,200));
    frecuencia=input('Configure una frecuencia y presione Enter o deje en blanco para salir: ');
% medir=~contains(entrada,'n');
medir=~isempty(frecuencia);
end
% nombreArchivo=input('Nombre del archivo: ','s');
save([nombreArchivo '.mat'],'resultados');
disp(['Datos guardados en archivo ' nombreArchivo '.mat']);
sound(rand(1,512));
set(oscilloscopeHandler.Acquisition(responseChannel), 'Control', 'run-stop');
set(oscilloscopeHandler.Acquisition(responseChannel), 'State', 'run');

    function adjustChannel(channelNumber,oscilloscopeHandler)
        goToVoltage(2.5,channelNumber,1);
        [~,amplitudes]=readOscilloscopeChannel(channelNumber,oscilloscopeHandler);
        setAmplitude=max(amplitudes)-min(amplitudes);
        setOffset=(max(amplitudes)+min(amplitudes))/2;
        if setAmplitude<1
            goToVoltage(setOffset,channelNumber,.13);
            [~,amplitudes]=readOscilloscopeChannel(channelNumber,oscilloscopeHandler);
            setAmplitude=max(amplitudes)-min(amplitudes);
            setOffset=(max(amplitudes)+min(amplitudes))/2;
            if setAmplitude<150e-3
                goToVoltage(setOffset,channelNumber,.025);
                [~,amplitudes]=readOscilloscopeChannel(channelNumber,oscilloscopeHandler);
                setAmplitude=max(amplitudes)-min(amplitudes);
            else
                goToVoltage(setOffset,channelNumber,setAmplitude/7);
            end
        else
            goToVoltage(setOffset,channelNumber,setAmplitude/7);
        end
        
%         setOffset=(max(amplitudes)+min(amplitudes))/2;
        
    end

    function waitSingleCapture(oscilloscopeHandler)
        set(oscilloscopeHandler.Acquisition(1), 'Control', 'run-stop');
        set(oscilloscopeHandler.Acquisition(1), 'State', 'run');
        set(oscilloscopeHandler.Acquisition(1), 'Control', 'single');
        while strcmp(get(oscilloscopeHandler.Acquisition(1), 'State'),'run')
        end
    end

    function setFrecuency(oscilloscopeHandler,frecuencia)
        period=1/frecuencia;
        timeBase=4*period/10;
        set(oscilloscopeHandler.Acquisition, 'Timebase', timeBase);
    end

end
