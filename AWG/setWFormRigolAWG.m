function setWFormRigolAWG(frequency,amplitude,offset,awgHandler,varargin)
sf=num2str(frequency);
sa=num2str(amplitude);
so=num2str(offset);
commandStr=['APPL:SIN ' sf ',' sa ',' so];
fprintf(awgHandler, commandStr);
end