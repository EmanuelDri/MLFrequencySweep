function figureHandler=generateBode(f,amps)
figure;
figureHandler=semilogx(f,amps);
title('Gr�fica Bode')
xlabel('Frecuencia [Hz]');
ylabel('Amplitud [dB]');
end