function goToVoltage(offset,channel,scale)
deviceObj=connectTektronixOscilloscope();
% set(deviceObj.Acquisition(1), 'Delay', tp+270e-6);

tektronixGotoVoltageLevel(offset,channel,scale,deviceObj);

     function tektronixGotoVoltageLevel(voltage,channel,scale,deviceObj)
        position=-voltage/scale;
        set(deviceObj.Channel(channel), 'Position', position);
        set(deviceObj.Channel(channel), 'Scale', scale);
    end


end