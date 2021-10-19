clc
clear all;
close all;
%Fs = 360; % Sampling Frequency
%N = 50; % Order
Fc = 0.6; % Cutoff Frequency
% Construct an FDESIGN object and call its BUTTER method.
[signal,Fs]=rdsamp('mitdb/100',[],10000);
%Fc=powerbw(signal,Fs);
%h = fdesign. highpass ('N,Fc', N, Fc, Fs);
[b,a] = butter(3,Fc/(Fs/2),'high');

%x=load('100'); % load the ECG signal
x1=signal(:,2);
x2=x1./ max(x1);
subplot (5,1,1), plot(x2), title ('ECG Signal with low-frequency(baseline wander) noise'), grid on
y0=filtfilt(b,a, x2);
subplot (5,1,2), plot(y0), title ('ECG signal with baseline wander REMOVED'), grid on
[signal,Fs]=rdsamp('mitdb/113',[],10000);
y2= (signal (:,1)); % ECG signal data
a1= (signal (:,1)); % accelerometer x-axis data
a2= (signal (:,1)); % accelerometer y-axis data
a3= (signal (:,1)); % accelerometer z-axis data
y2 = y2/max (y2);
subplot (5, 1, 3), plot (y2), title ('ECG Signal with motionartifacts'), grid on
a = a1+a2+a3;
a=a/max (a);
mu= 0.0008;
Hd = dsp.LMSFilter('Length',32,'StepSize', mu);
%Hd = adaptfilt.lms(32,mu);
[s2, e] = Hd(y2,a);
subplot (5, 1, 4); plot (s2), title ('Noise (motion artifact)estimate'), grid on
subplot (5, 1, 5), plot (e), title ('Adaptively filtered/ Noise freeECG signal'), grid on