function figureHandler=generateBode(f,amps)
figureHandler=semilogx(f,amps);
title('Gr�fica Bode')
xlabel('Frecuencia [Hz]');
ylabel('Amplitud [dB]');
end