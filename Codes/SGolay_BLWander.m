clearvars
clc
close all

signal = load ("118e00m.csv");
signal = signal(1:9000, 1);
subplot(3, 1, 1);
plot(signal);
title("Unfiltered Signal");

order = 5;
framelen = 51;
signalFiltered_1 = sgolayfilt(signal, order, framelen);
subplot(3, 1, 2);
plot(signalFiltered_1);
title("Filtered Signal");
avg = 0.5;
for i = 301:1:length(signalFiltered_1)
    signalFiltered_1(i) = signalFiltered_1(i) - (sum(signalFiltered_1(i-300:1))/300);
end

subplot(3, 1, 3);
signalFiltered_2 = signalFiltered_1 - avg;
plot(signalFiltered_2);