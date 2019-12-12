function awgHandler=connectRigolAWG
%% Instrument Connection

% Find a VISA-USB object.
awgHandler = instrfind('Type', 'visa-usb', 'RsrcName', 'USB0::0x09C4::0x0400::DG1D162450485::0::INSTR', 'Tag', '');

% Create the VISA-USB object if it does not exist
% otherwise use the object that was found.
if isempty(awgHandler)
    awgHandler = visa('TEK', 'USB0::0x09C4::0x0400::DG1D162450485::0::INSTR');
else
    fclose(awgHandler);
    awgHandler = awgHandler(1);
end

% Connect to instrument object, obj1.
fopen(awgHandler);