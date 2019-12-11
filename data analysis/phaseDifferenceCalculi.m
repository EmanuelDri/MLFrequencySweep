function [f,phases]=phaseDifferenceCalculi(sweepData)
f=cell2mat(sweepData(:,5));
[measNumber,~]=size(sweepData);
phases=zeros(1,measNumber);
for index=1:measNumber
    yout=sweepData{index,2};
    yin=sweepData{index,4};
    phases(index)=phdiffmeasure(yin,yout);
end