function figureHandler=generateBode(f,amps)
figure;
figureHandler=semilogx(f,amps);
title('Gráfica Bode')
xlabel('Frecuencia [Hz]');
ylabel('Amplitud [dB]');
end