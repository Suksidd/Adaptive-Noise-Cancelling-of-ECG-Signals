clearvars
clc
close all

signal = load ("118e_6m.csv");
signal = signal(4001:6000, 1);
subplot(2, 1, 1);
plot(signal);
title("Unfiltered Signal");

order = 2;
framelen = 25;
signalFiltered_1 = sgolayfilt(signal, order, framelen);
subplot(2, 1, 2);
plot(signalFiltered_1);
title("Filtered Signal");