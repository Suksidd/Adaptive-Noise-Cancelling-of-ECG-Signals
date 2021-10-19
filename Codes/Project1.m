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
subplot (2,1,1), plot(x2), title ('ECG Signal with low-frequency(baseline wander) noise'), grid on
y0=filtfilt(b,a, x2);
subplot (2,1,2), plot(y0), title ('ECG signal with baseline wander REMOVED'), grid on