clearvars
clc
close all
file = load("ECG_PhysioNet.mat");

signal = file.signal(1:1000, 1);
Fs = file.Fs;
subplot(2, 1, 1);
plot(signal);
N = length(signal);
filtered_SIGNAL = zeros(1, N);

for i = 1:1:N
   filtered_SIGNAL(i) = KALMAN(signal(i)); 
end

subplot(2, 1, 2);
plot(filtered_SIGNAL);
function U_Hat = KALMAN (U)
    persistent A B R H Q P U_H K;
    if(isempty(R))
        R = 10;
        H = 1;
        Q = 1;
        P = 0;
        U_H = 0;
        K = 0;
        A = 2;
        B = 0;
        %K = 0;
    end
    U_H = (A * U_H) + (B * 0);
    P = (A*P*A) + Q;
    K = (P * H) / (H * P * H + R);
    U_H = U_H + (K * (U - H * U_H));
    
    P = (1 - K * H)*P + Q;
    U_Hat = U_H;
end