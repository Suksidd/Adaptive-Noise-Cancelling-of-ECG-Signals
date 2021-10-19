clear all
clc
close all

signal = load ("118e00m.mat");
signal = signal.val;
signal = signal(1,1:21600);
subplot(2, 1, 1);
plot(signal(10000:15000));
title("Unfiltered Signal");

order = 5;
framelen = 51;
signalFiltered_1 = sgolayfilt(signal, order, framelen);
subplot(2, 1, 2);
plot(signalFiltered_1(10000:15000));
title("Filtered Signal");