function [x,y]=readOscilloscopeChannel(channel,oscilloscopeHandler)
if (channel==1)
    channelString='channel1';
else
    channelString='channel2';
end

% Execute device object function(s).
oscilloscopeFeature = get(oscilloscopeHandler, 'Waveform');
oscilloscopeFeature = oscilloscopeFeature(1);
[y,x] = invoke(oscilloscopeFeature, 'readwaveform', channelString);
end