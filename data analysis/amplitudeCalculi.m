function [f,amps]=amplitudeCalculi(sweepData)
[measNumber,~]=size(sweepData);
f=zeros(1,measNumber);
amps=zeros(1,measNumber);

for measIndex=1:measNumber
    measurementData=sweepData(measIndex,:);
    xout=measurementData{1};
    yout=measurementData{2};
    xin=measurementData{3};
    yin=measurementData{4};
    frequency=measurementData{5};
    inputAmplitude=max(yin)-min(yin);
    outputAmplitude=max(yout)-min(yout);
    gain=20*log10(outputAmplitude/inputAmplitude);
    f(measIndex)=frequency;
    amps(measIndex)=gain;
end