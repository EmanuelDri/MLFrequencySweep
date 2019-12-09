function  oscilloscopeHandler=connectTektronixOscilloscope(varargin)
if nargin==0
    oscilloscopeAddress='USB0::0x0699::0x0368::C013989::0::INSTR';
else
    oscilloscopeAddress=varargin{1};
end
    
% Create a VISA-USB object.
% interfaceObj = instrfind('Type', 'visa-usb', 'RsrcName', oscilloscopeAddress, 'Tag', '');
interfaceObj = instrfind('Type', 'visa-usb', 'RsrcName', 'USB0::0x0699::0x0368::C013989::0::INSTR', 'Tag', '');

% Create the VISA-USB object if it does not exist
% otherwise use the object that was found.
if isempty(interfaceObj)
    interfaceObj = visa('TEK', 'USB0::0x0699::0x0368::C013989::0::INSTR');
else
    fclose(interfaceObj);
    interfaceObj = interfaceObj(1);
end

% Create a device object. 
deviceObj = icdevice('tektronix_tds1002.mdd', interfaceObj);

% Connect device object to hardware.
connect(deviceObj);

oscilloscopeHandler=deviceObj;
end