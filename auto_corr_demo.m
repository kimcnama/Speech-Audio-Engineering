% ex102.m
% modified version from http://www.phon.ucl.ac.uk/courses/spsci/matlab/lect10.html
% get a waveform
fn=input('Enter WAV filename : ','s');
[x,fs]=audioread(fn);

% work out corresponding number of samples for X milliseconds for this fs
% value
ms2=floor(fs*0.002);
ms10=floor(fs*0.01);
ms20=floor(fs*0.02);
ms30=floor(fs*0.03);

% plot waveform
t=(0:length(x)-1)/fs;
subplot(2,1,1);
plot(t,x);
legend('Waveform');
xlabel('Time (s)');
ylabel('Amplitude');
% process in chunks
pos=1;
fx=[];
while (pos+ms30) <= length(x)
    y=x(pos:pos+ms30-1);
    y=y-mean(y);
    %plot chunk of speech
    figure
    subplot(2,1,1);
    t=(0:length(y)-1)/fs;
    plot(t,y);
    legend('Waveform');
    xlabel('Time (s)');
    ylabel('Amplitude');
    
    % calculate autocorrelation
    % could use this basic windowing for other applications too
    r=xcorr(y,ms20,'coeff');    
    
    % plot autocorrelation
    d=(-ms20:ms20)/fs;          % times of delays
    subplot(2,1,2);
    plot(d,r);
    legend('Autocorrelation');
    xlabel('Delay (s)');
    ylabel('Correlation coeff.');
    r=r(ms20+1:2*ms20+1);
    % search for maximum  between 2ms (=500Hz) and 20ms (=50Hz)
    [rmax,fxval]=max(abs(r(ms2:ms20)));
    if (rmax > 0.5)
        fx=[fx fs/(ms2+fxval-1)];
    else
        fx=[fx 0];
    end;
    pos=pos+ms10;
    pause % for demo purposes, hit return to get more
    close all
    
end;
% plot FX trace
t=(0:length(fx)-1)*0.01;
subplot(2,1,2);
plot(t,fx);
legend('FX Trace');
xlabel('Time (s)');
ylabel('Frequency (Hz)');