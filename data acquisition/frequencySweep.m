function [resultados]=frequencySweep(nombreArchivo,responseChannel,varargin)

performManualSweep=true;
if ~isempty(varargin)&&ischar(varargin{1})&&contains(varargin{1},'auto')
    performManualSweep=false;
end

delete(instrfind);
inputChannel=selectInputChannel(responseChannel);
oscilloscopeHandler=connectTektronixOscilloscope();
oscilloscopeSetup(oscilloscopeHandler,inputChannel,responseChannel);

if performManualSweep
    resultados=manualSweep(oscilloscopeHandler,responseChannel,inputChannel);
else
    resultados=autoSweep(oscilloscopeHandler,responseChannel,inputChannel);
end


save([nombreArchivo '.mat'],'resultados');
disp(['Datos guardados en archivo ' nombreArchivo '.mat']);
sound(rand(1,512));
setOscilloscopeRun(oscilloscopeHandler)

    function inputChannel=selectInputChannel(responseChannel)
        switch responseChannel
            case 1
                inputChannel=2;
            case 2
                inputChannel=1;
            otherwise
                inputChannel=2;
        end
    end

    function resultados=manualSweep(oscilloscopeHandler,responseChannel,inputChannel)
        resultados=cell(0,5);
        inputMessage='Configure una frecuencia y presione Enter o deje en blanco para salir: ';
        frecuencia=input(inputMessage);
        % medir=~contains(entrada,'n');
        measure=~isempty(frecuencia);
        while measure
            batch=measurementBatch(oscilloscopeHandler,3,frecuencia,responseChannel,inputChannel);
            resultados=[resultados;batch];
            sound(rand(1,200));
            frecuencia=input(inputMessage);
            % medir=~contains(entrada,'n');
            measure=~isempty(frecuencia);
        end
    end
    function resultados=autoSweep(oscilloscopeHandler,responseChannel,inputChannel)
        resultados=cell(0,5);
        frequencies=[30:10:100 100:100:1700 1710:10:2100 2100:100:3500,...
            4000:500:10000 11000:1000:20000];
        awgHandler=connectRigolAWG();
        for findex=1:length(frequencies)
            frecuencia=frequencies(findex);
            setWFormRigolAWG(frecuencia,1,2.5,awgHandler);
            setWFormRigolAWG(frecuencia,1,2.5,awgHandler);
            batch=measurementBatch(oscilloscopeHandler,3,frecuencia,responseChannel,inputChannel);
            resultados=[resultados;batch];
        end
    end

    function adjustChannel(channelNumber,oscilloscopeHandler)
        goToVoltage(2.5,channelNumber,1,oscilloscopeHandler);
        [~,amplitudes]=readOscilloscopeChannel(channelNumber,oscilloscopeHandler);
        setAmplitude=max(amplitudes)-min(amplitudes);
        setOffset=(max(amplitudes)+min(amplitudes))/2;
        if setAmplitude<1
            goToVoltage(setOffset,channelNumber,.13,oscilloscopeHandler);
            [~,amplitudes]=readOscilloscopeChannel(channelNumber,oscilloscopeHandler);
            setAmplitude=max(amplitudes)-min(amplitudes);
            setOffset=(max(amplitudes)+min(amplitudes))/2;
            if setAmplitude<150e-3
                goToVoltage(setOffset,channelNumber,.025,oscilloscopeHandler);
                [~,amplitudes]=readOscilloscopeChannel(channelNumber,oscilloscopeHandler);
                setAmplitude=max(amplitudes)-min(amplitudes);
            else
                goToVoltage(setOffset,channelNumber,setAmplitude/7,oscilloscopeHandler);
            end
        else
            goToVoltage(setOffset,channelNumber,setAmplitude/7,oscilloscopeHandler);
        end
        
        %         setOffset=(max(amplitudes)+min(amplitudes))/2;
        
    end

    function oscilloscopeSetup(oscilloscopeHandler,inputChannel,responseChannel)
        set(oscilloscopeHandler.Channel(1), 'BandwidthLimit', 'on');
        set(oscilloscopeHandler.Channel(2), 'BandwidthLimit', 'on');
        set(oscilloscopeHandler.Channel(1), 'Coupling', 'dc');
        set(oscilloscopeHandler.Channel(2), 'Coupling', 'dc');
        set(oscilloscopeHandler.Channel(1), 'State', 'on');
        set(oscilloscopeHandler.Acquisition(1), 'Mode', 'average');
        set(oscilloscopeHandler.Acquisition(1), 'NumberOfAverages', 128.0);
        setOscilloscopeRun(oscilloscopeHandler)
        adjustChannel(inputChannel,oscilloscopeHandler);
    end

    function waitSingleCapture(oscilloscopeHandler)
        setOscilloscopeRun(oscilloscopeHandler);
        set(oscilloscopeHandler.Acquisition(1), 'Control', 'single');
        while strcmp(get(oscilloscopeHandler.Acquisition(1), 'State'),'run')
        end
    end

    function setFrecuency(oscilloscopeHandler,frecuencia)
        timeBasePatterns=[1 2.5 5];
        period=1/frecuencia;
        calculatedTimeBase=4*period/10;
        exponent=-floor(log10(calculatedTimeBase));
        rawTimeBase=calculatedTimeBase*10^exponent;
        if rawTimeBase<=5
           oscTimeBase=min(timeBasePatterns(timeBasePatterns>=rawTimeBase))*10^-exponent;
        else
            oscTimeBase=10^(-exponent+1);
        end
        set(oscilloscopeHandler.Acquisition, 'Timebase', oscTimeBase);
    end

    function setOscilloscopeRun(oscilloscopeHandler)
        set(oscilloscopeHandler.Acquisition(1), 'Control', 'run-stop');
        set(oscilloscopeHandler.Acquisition(1), 'State', 'run');
    end

    function [xch1,ych1,xch2,ych2]=getOscilloscopeCapture(oscilloscopeHandler,responseChannel,inputChannel)
        waitSingleCapture(oscilloscopeHandler);
        [xch1,ych1]=readOscilloscopeChannel(responseChannel,oscilloscopeHandler);
        [xch2,ych2]=readOscilloscopeChannel(inputChannel,oscilloscopeHandler);
    end

    function batch=measurementBatch(oscilloscopeHandler,iterations,frecuencia,responseChannel,inputChannel)
        setFrecuency(oscilloscopeHandler,frecuencia)
        adjustChannel(responseChannel,oscilloscopeHandler);
        batch=cell(iterations,5);
        for iteration=1:iterations
            [t1,y1,t2,y2]=getOscilloscopeCapture(oscilloscopeHandler,responseChannel,inputChannel);
            disp('Datos capturados');
            batch(iteration,:)={t1;y1;t2;y2;frecuencia};
            %             setOscilloscopeRun(oscilloscopeHandler)
        end
    end

end
